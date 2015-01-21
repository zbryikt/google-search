require! <[./index]>

index.get \自住 .then -> console.log it
index.getPages(\自住, [i for i from 1 to 3]).then -> console.log it
