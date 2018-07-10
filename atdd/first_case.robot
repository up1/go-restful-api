*** Settings ***
Library   RequestsLibrary
Library	  Collections

*** Variables ***

*** Testcases ***
Try to add one product to empty basket
  Search product by keyword adidas
  Get product detail of id=1000
  Add product id=1000 to empty basket
  Get basket detail of id=1

*** Keywords ***
Search product by keyword adidas
  Create Session    search    http://localhost:8882
  ${response}=  Get Request  search  /search?q=adidas
  Should Be Equal   ${response.status_code}  ${200}
  Should Be Equal   ${response.json()['header']['code']}   ${200}
  ${size_of_product}=  Get length  ${response.json()['body']}
  Should Be Equal   ${size_of_product}  ${2}
  Should Be Equal   ${response.json()['body'][0]['product_id']}  ${1000}

Get product detail of id=1000
  Create Session    product    http://localhost:8882
  ${response}=  Get Request  product  /product/1000
  Should Be Equal As Strings  ${response.status_code}  200

Add product id=1000 to empty basket
  Create Session    baskets    http://localhost:8882
  &{headers}=  Create Dictionary  Content-Type=application/json
  &{data}=  Create Dictionary
  ...  product_id=${1000}
  ...  product_name=Adidas
  ...  product_price=${1500}
  ...  product_image=http://xxx.jpg
  ...  quantity=${1}
  ${response}=  Post Request  baskets  /baskets  data=${data}  headers=${headers}
  Should Be Equal As Strings  ${response.status_code}  200

Get basket detail of id=1
  Create Session    baskets    http://localhost:8882
  ${response}=  Get Request  baskets  /baskets/1
  Should Be Equal As Strings  ${response.status_code}  200
