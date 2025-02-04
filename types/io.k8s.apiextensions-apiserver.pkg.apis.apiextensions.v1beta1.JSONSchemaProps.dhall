{ additionalItems :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrBool.dhall
, additionalProperties :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrBool.dhall
, default :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSON.dhall
, definitions :
    List { mapKey : Text, mapValue : Text }
, dependencies :
    List { mapKey : Text, mapValue : Text }
, enum :
    List
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSON.dhall
, example :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSON.dhall
, externalDocs :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.ExternalDocumentation.dhall
, items :
    ./io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrArray.dhall
, patternProperties :
    List { mapKey : Text, mapValue : Text }
, properties :
    List { mapKey : Text, mapValue : Text }
, required :
    List Text
, `$ref` :
    Optional Text
, `$schema` :
    Optional Text
, description :
    Optional Text
, exclusiveMaximum :
    Optional Bool
, exclusiveMinimum :
    Optional Bool
, format :
    Optional Text
, id :
    Optional Text
, maxItems :
    Optional Natural
, maxLength :
    Optional Natural
, maxProperties :
    Optional Natural
, maximum :
    Optional Double
, minItems :
    Optional Natural
, minLength :
    Optional Natural
, minProperties :
    Optional Natural
, minimum :
    Optional Double
, multipleOf :
    Optional Double
, nullable :
    Optional Bool
, pattern :
    Optional Text
, title :
    Optional Text
, type :
    Optional Text
, uniqueItems :
    Optional Bool
}
