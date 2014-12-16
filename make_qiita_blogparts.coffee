
casper = require("casper").create()

target_url = "http://qiita.com/organizations/yumemi"

# 対象のWEBページを開く
casper.start target_url, ->

  # ----------------------------
  # アイコン画像のURL を取得
  # ----------------------------

  author_icons = []

  author_icons = @evaluate ->
    items = document.querySelectorAll("article .publicItem_left img")
    Array::map.call items, (e) ->
      e.getAttribute('src')
  #@echo(" - " + author_icons.join("\n - "))

  # ----------------------------
  # 投稿者名 を取得
  # ----------------------------

  author_names = []

  author_names = @evaluate ->
    items = document.querySelectorAll("article .publicItem_main .publicItem_header a")
    Array::map.call items, (e) ->
      e.text
  #@echo(" - " + author_names.join("\n - "))

  # ----------------------------
  # 投稿者個人ページのURL を取得
  # ----------------------------

  author_urls = []

  author_urls = @evaluate ->
    items = document.querySelectorAll("article .publicItem_main .publicItem_header a")
    Array::map.call items, (e) ->
      e.getAttribute('href')
  #@echo(" - " + author_urls.join("\n - "))

  # ----------------------------
  # 投稿日時(投稿しましたテキスト付き) を取得
  # ----------------------------

  entry_days = []

  entry_days = @evaluate ->
    items = document.querySelectorAll("article .publicItem_main .publicItem_header")
    Array::map.call items, (e) ->
      e.innerHTML

  # 余分なタグを削除
  i = 0
  while i < entry_days.length
    # innerHTML 内の aタグエリアを削除
    entry_days[i] = entry_days[i].replace(/<a href=.+?<\/a>/g,"")
    i++

  #@echo(" - " + entry_days.join("\n - "))

  # ----------------------------
  # 投稿コンテンツのタイトル を取得
  # ----------------------------

  entry_titles = []

  entry_titles = @evaluate ->
    items = document.querySelectorAll("article .publicItem_main .publicItem_body a[href*=\"/items/\"]")
    Array::map.call items, (e) ->
      e.text
  #@echo(" - " + entry_titles.join("\n - "))

  # ----------------------------
  # 投稿コンテンツのURL を取得
  # ----------------------------

  entry_urls = []

  entry_urls = @evaluate ->
    items = document.querySelectorAll("article .publicItem_main .publicItem_body a[href*=\"/items/\"]")
    Array::map.call items, (e) ->
      e.getAttribute('href');
  #@echo(" - " + entry_urls.join("\n - "))

  # ----------------------------
  # HTMLの組み立て
  # ----------------------------

  html = ""
  html += "<table style='background-color: #64C914'>"
  html += "    <tr>"
  html += "        <td>"
  html += "            <table>"
  html += "                <tr>"
  html += "                    <td align='center'>"
  html += "                        <img src='https://pbs.twimg.com/profile_images/1542801560/Qiita_normal.png' width='50'>"
  html += "                    </td>"
  html += "                    <td algin='left'>"
  html += "                        <font size='2px' color='white'>"
  html += "                            &nbsp;&nbsp;&nbsp;&nbsp;<a href='http://qiita.com/organizations/yumemi' target='_blank'><font color='white'>ゆめみメンバーのQiita</font></a> 新着投稿！"
  html += "                        </font>"
  html += "                    </td>"
  html += "                </tr>"
  html += "            </table>"
  html += "        </td>"
  html += "    </tr>"
  html += "    <tr>"
  html += "        <td>"

  i = 0
  while i < author_icons.length
    html_tmp = ""
    html_tmp += "            <table style='background-color: white;' width='100%'>"
    html_tmp += "                <tr>"
    html_tmp += "                    <td width='60' align='center'>"
    html_tmp += "                        <a href='#AUTHOR_URL#' target='_blank'>"
    html_tmp += "                            <img src='#AUTHOR_ICON#' width='50'>"
    html_tmp += "                        </a>"
    html_tmp += "                    </td>"
    html_tmp += "                    <td>"
    html_tmp += "                        <table>"
    html_tmp += "                            <tr>"
    html_tmp += "                                <td>"
    html_tmp += "                                    <font size='1px'>"
    html_tmp += "                                        <a href='#AUTHOR_URL#' style='text-decoration: none;' target='_blank'>"
    html_tmp += "                                            <font color='#6495ed'>"
    html_tmp += "                                                #AUTHOR_NAME#"
    html_tmp += "                                            </font>"
    html_tmp += "                                        </a>"
    html_tmp += "                                        <font color='#696969'>"
    html_tmp += "                                            &nbsp;#ENTRY_DAY#"
    html_tmp += "                                        </font>"
    html_tmp += "                                    </font>"
    html_tmp += "                                </td>"
    html_tmp += "                            </tr>"
    html_tmp += "                            <tr>"
    html_tmp += "                                <td>"
    html_tmp += "                                    <font size='2px'>"
    html_tmp += "                                        <a href='#ENTRY_URL#' style='text-decoration: none;' target='_blank'>"
    html_tmp += "                                            <font color='#6495ed'>"
    html_tmp += "                                                #ENTRY_TITLE#"
    html_tmp += "                                            </font>"
    html_tmp += "                                        </a>"
    html_tmp += "                                    </font>"
    html_tmp += "                                </td>"
    html_tmp += "                            </tr>"
    html_tmp += "                        </table>"
    html_tmp += "                    </td>"
    html_tmp += "                </tr>"
    html_tmp += "            </table>"

    html_tmp = html_tmp.replace(/#AUTHOR_ICON#/g, author_icons[i])
    html_tmp = html_tmp.replace(/#AUTHOR_NAME#/g, author_names[i])
    html_tmp = html_tmp.replace(/#AUTHOR_URL#/g, "http://qiita.com" + author_urls[i])
    html_tmp = html_tmp.replace(/#ENTRY_DAY#/g, entry_days[i])
    html_tmp = html_tmp.replace(/#ENTRY_TITLE#/g, entry_titles[i])
    html_tmp = html_tmp.replace(/#ENTRY_URL#/g, "http://qiita.com" + entry_urls[i])

    html += html_tmp
    if (i + 1) < author_icons.length
      html += "            <hr color='#64C914' style='margin: 0px 0px 0px 0px'>"
    i++

  html += "        </td>"
  html += "    </tr>"
  html += "</table>"

  @echo html

  # ----------------------------
  # JavaScript の document.writeで出力
  # ----------------------------

  #output = ""
  #output = "document.write(\"" + html + "\");"
  #@echo output

casper.run ->
  @exit()
