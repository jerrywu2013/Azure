library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()


req = list(
  
  Inputs = list(
    
    
    "input1" = list(
      "ColumnNames" = list("sepal length", "sepal width", "petal length", "petal width", "class"),
      "Values" = list( list( "1.7", "1.5", "1.8", "1.9", "value" ),  list( "5", "6", "8", "8", "value" )  )
    )                ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)

body = enc2utf8(toJSON(req))
api_key = "Zz3A6JtXaUa5C0ap4ytoq6oq7yMIa64Z/LI2eOh9Hh8s9D2kcv9nTG8a32z36/VHmBOvStHKaDMmMjYJMVmN5A==" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()
curlPerform(url = "https://asiasoutheast.services.azureml.net/workspaces/bfecc13d26374ae28714f86312cf58cf/services/ca2469bd20304526ac782b6d8960b6a4/execute?api-version=2.0&details=true",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

print("Result:")
result = h$value()
print(fromJSON(result))