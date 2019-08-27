module Main (main) where

import qualified Data.Map.Strict                       as Data.Map
import qualified Data.Text                             as Text
import qualified Data.Text.Prettyprint.Doc             as Pretty
import qualified Data.Text.Prettyprint.Doc.Render.Text as PrettyText
import qualified Dhall.Core                            as Dhall
import qualified Dhall.Format
import qualified Dhall.Pretty
import qualified Turtle

import           Data.Aeson                            (eitherDecodeFileStrict)
import           Data.Foldable                         (for_)
import           Data.Text                             (Text)
import           System.Environment                    (getArgs)

import qualified Dhall.Kubernetes.Convert              as Convert
import           Dhall.Kubernetes.Data                 (patchCyclicImports)
import           Dhall.Kubernetes.Types


-- | Write and format a Dhall expression to a file
writeDhall :: Turtle.FilePath -> Expr -> IO ()
writeDhall path expr = do
  echoStr $ "Writing file '" <> Turtle.encodeString path <> "'"
  Turtle.writeTextFile path $ pretty expr <> "\n"
  Dhall.Format.format
    (Dhall.Format.Format Dhall.Pretty.ASCII $ Dhall.Format.Modify (Just $ Turtle.encodeString path))

-- | Pretty print things
pretty :: Pretty.Pretty a => a -> Text
pretty = PrettyText.renderStrict
  . Pretty.layoutPretty Pretty.defaultLayoutOptions
  . Pretty.pretty

echo :: Turtle.MonadIO m => Text -> m ()
echo = Turtle.printf (Turtle.s Turtle.% "\n")

echoStr :: Turtle.MonadIO m => String -> m ()
echoStr = echo . Text.pack


main :: IO ()
main = do
  -- Get the Swagger spec
  args <- getArgs
  Swagger{..} <- case args of
    [file] -> do
      swaggerFile <- eitherDecodeFileStrict file
      case swaggerFile of
        Left msg -> fail msg
        Right s  -> pure s
    _ -> error "You need to provide a filename as first argument"

  -- Convert to Dhall types in a Map
  let types = Convert.toTypes
        -- TODO: find a better way to deal with this cyclic import
         $ Data.Map.adjust patchCyclicImports
            (ModelName "io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps")
            definitions

  -- Output to types
  Turtle.mktree "types"
  for_ (Data.Map.toList types) $ \(ModelName name, expr) -> do
    let path = "./types" Turtle.</> Turtle.fromText (name <> ".dhall")
    writeDhall path expr

  -- Convert from Dhall types to defaults
  let defaults = Data.Map.mapMaybeWithKey (Convert.toDefault definitions types) types

  -- Output to defaults
  Turtle.mktree "defaults"
  for_ (Data.Map.toList defaults) $ \(ModelName name, expr) -> do
    let path = "./defaults" Turtle.</> Turtle.fromText (name <> ".dhall")
    writeDhall path expr

  -- Output the types record, the defaults record, and the giant union type
  let objectNames = Data.Map.keys types
      typesMap = Convert.getImportsMap objectNames "types" $ Data.Map.keys types
      defaultsMap = Convert.getImportsMap objectNames "defaults" $ Data.Map.keys defaults

      typesRecordPath = "./types.dhall"
      typesUnionPath = "./typesUnion.dhall"
      defaultsRecordPath = "./defaults.dhall"

  writeDhall typesUnionPath (Dhall.Union $ fmap Just typesMap)
  writeDhall typesRecordPath (Dhall.RecordLit typesMap)
  writeDhall defaultsRecordPath (Dhall.RecordLit defaultsMap)
