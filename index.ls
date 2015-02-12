require! <[fs request bluebird cheerio]>

search = do
  get: (keyword, page=1) ->
    result = []
    (res, rej) <- new bluebird _
    (e,r,b) <- request {
      url: "https://www.google.com.tw/search?q=#{encodeURIComponent(keyword)}&start=#{(page - 1)* 10}"
      method: \GET
      headers: do
        "Accept-Charset": "UTF-8"
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"
    }, _
    if e or !b => return rej!
    $ = cheerio.load b
    titles = []
    fs.write-file-sync \body.html, b
    for item in $(".g")
      href = $(item).find(".r a").attr("href")
      ret = /^\/url\?q=([^&]+)&/.exec href
      if ret => href = decodeURIComponent ret.1
      if !href => continue
      title = $(item).find(".r a").text!
      content = $(item).find(".s .st").text!
      result.push {href, title, content}
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
