*** Settings ***
Library  Collections
Library  RequestsLibrary
Suite Setup   Create all session of services

*** Variables ***
${SEARCH_SERVICE}   ${EMPTY}
${PRODUCT_SERVICE}   ${EMPTY}
${BASKET_SERVICE}   ${EMPTY}

*** Testcases ***
Success with ordered one product
  ${selected product id}=  Search product by adidas
  &{product}=  Show product detail  ${selected product id}
  ${basket_id}=  Add selected product to basket   ${product}
  Check basket  ${basket_id}

*** Keywords ***
Create all session of services
  Create Session   ${SEARCH_SERVICE}  http://10.10.99.5:8882
  Create Session   ${PRODUCT_SERVICE}  http://10.10.99.5:8882
  Create Session   ${BASKET_SERVICE}  http://10.10.99.5:8882

Check basket
  [Arguments]  ${basket_id}
  ${response}=  Get Request    ${BASKET_SERVICE}    /baskets/${basket_id}
  Should Be Equal    ${response.status_code}    ${200}

Add selected product to basket
  [Arguments]  ${product}
  &{headers}=  Create Dictionary    Content-Type=application/json
  &{datas}=  Create Dictionary
  ...  product_id=${product['product_id']}
  ...  product_name=${product['product_name']}
  ...  product_price=${product['product_price']}
  ...  product_image=${product['product_image']}
  ...  quantity=${1}
  ${response}=  Post Request    ${BASKET_SERVICE}
  ...  /baskets
  ...  headers=${headers}
  ...  data=${datas}
  Should Be Equal    ${response.status_code}    ${200}
  [Return]   ${response.json()['body']['basket_id']}

Show product detail
  [Arguments]  ${product_id}
  ${response}=  Get Request    ${PRODUCT_SERVICE}    /product/${product_id}
  Should Be Equal    ${response.status_code}    ${200}
  [Return]  ${response.json()['body']}

Search product by adidas
  &{headers}=  Create Dictionary    Content-Type=application/json
  ${response}=  Get Request    ${SEARCH_SERVICE}    /search?q=adidas  headers=${headers}
  Should Be Equal    ${response.status_code}    ${200}
  ${size}=  Get Length    ${response.json()['body']}
  Should Be Equal    ${size}    ${2}
  [Return]   ${response.json()['body'][0]['product_id']}
