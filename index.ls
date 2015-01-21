require! <[fs request bluebird cheerio]>

search = do
  get: (keyword, page=1) ->
    result = []
    (res, rej) <- new bluebird _
    (e,r,b) <- request {
      url: "https://www.google.com.tw/search?q=#{encodeURIComponent(keyword)}}&start=#{(page - 1)* 10}"
      method: \GET
    }, _
    if e or !b => return rej!
    $ = cheerio.load b
    for item in $(".g .r a")
      ret = /^\/url\?q=([^&]+)&/.exec $(item).attr("href")
      if !ret => continue
      href = decodeURIComponent ret.1
      result.push href
    return res result
  _getPages: (keyword, pages=[], result, res, rej) ->
    if !pages.length => return res result
    page = pages.splice(0,1)
    @get(keyword, page).then (list) ~>
      result ++= list
      @_getPages keyword, pages, result, res, rej
    .catch rej
  getPages: (keyword, pages=[]) -> new bluebird (res, rej) ~>
    @_getPages keyword, pages, [], res, rej

module.exports = search
