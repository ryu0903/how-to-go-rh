User.create!(
  [       
    { name:  "採用　一郎",
      email: "recruit@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    },
        
    { name:  "佐藤　太郎",
      email: "satou@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    },
        
    { name:  "佐々木　花子",
      email: "sasaki@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
  ]
)


Destination.create!(
  [
    { user_id: 1,
      to: "京都",
      from: "名古屋",
      date: "2018-09-17",
      time: "30分",
      outline: "そうだ、京都行こう",
      detail: "のぞみですぐに着きます",
      notice: "夏の京都は非常に暑いです！",
      reference: "https://ja.kyoto.travel/",
      picture: open("#{Rails.root}/public/images/dest1.jpg")
    },
    
    { user_id: 1,
      to: "高尾山",
      from: "品川",
      date: "2019-10-31",
      time: "1時間20分",
      outline: "お手軽ハイキングへ行きましょう",
      detail: "山手線外回りに乗車→新宿で下車→京王線特急へ乗車→高尾山口まで",
      notice: "めちゃくちゃ混んでます！！",
      reference: "https://www.takaotozan.co.jp/course/",
      picture: open("#{Rails.root}/public/images/dest2.jpg")
    },
    
    { user_id: 1,
      to: "中国地方",
      from: "東京",
      date: "2017-08-25〜08-27",
      outline: "岡山、広島に行ってきました",
      reference: "",
      picture: open("#{Rails.root}/public/images/dest3.jpg"),
      schedules_attributes: [
                              { to: "宮島",
                                from: "倉敷",
                                date: "2020-08-26",
                                time: "2時間30分",
                                detail: "山陽自動車道でひたすら進み、廿日市ICで下車、その後フェリーに乗る",
                                notice: "船に乗れます",
                                picture: open("#{Rails.root}/public/images/dest4.jpg") }
                            ]
    },
    
    { user_id: 1,
      to: "フランス、ベルギー、オランダ",
      from: "東京",
      date: "2019-03-01〜03-10",
      outline: "ヨーロッパを回ってきました",
      reference: "https://www.visitflanders.com/ja/destinations/brussels/index.jsp",
      picture: open("#{Rails.root}/public/images/dest5.jpg"),
      schedules_attributes: [
                              { to: "ブリュッセル",
                                from: "パリ",
                                date: "2020-03-04",
                                time: "2時間",
                                detail: "パリ北駅からタリスに乗車し、ブリュッセル中央駅で下車",
                                notice: "パリ北駅周辺は治安が悪いので気をつけて！",
                                picture: open("#{Rails.root}/public/images/dest6.jpg") }
                            ]
    },
    
     { user_id: 2,
      to: "高山",
      from: "東京",
      date: "2016-02-17",
      time: "5時間",
      outline: "古都高山へ",
      detail: "首都圏から名古屋まで新幹線で向かい、特急ひだに乗り換えます",
      notice: "時間がかかる上に特急は揺れるので気をつけて",
      reference: "http://kankou.city.takayama.lg.jp/",
      picture: open("#{Rails.root}/public/images/dest7.jpg")
    },
    
    { user_id: 2,
      to: "小樽",
      from: "新千歳空港",
      date: "2020-01-13",
      time: "1時間",
      outline: "小樽まで",
      detail: "快速エアポートで一本でいけます",
      notice: "",
      reference: "",
      picture: open("#{Rails.root}/public/images/dest8.jpg")
    },
    
    { user_id: 2,
      to: "四国地方",
      from: "東京",
      date: "2019-03-28〜2019-03-30",
      outline: "3日で四国制覇してきました",
      reference: "https://hirome.co.jp/",
      picture: open("#{Rails.root}/public/images/dest9.jpg"),
      schedules_attributes: [
                              { to: "高知市",
                                from: "高松空港",
                                date: "2019-03-28",
                                time: "3時間",
                                detail: "高速で行きます",
                                notice: "途中で大歩危に寄れます",
                                picture: open("#{Rails.root}/public/images/dest10.jpg") }
                            ]
    },
    
    { user_id: 2,
      to: "ドイツ、オーストリア",
      from: "東京",
      date: "2018-10-25〜2018-11-03",
      outline: "中欧を回ってきました",
      reference: "https://www.arukikata.co.jp/city/MUC/",
      picture: open("#{Rails.root}/public/images/dest11.jpg"),
      schedules_attributes: [
                              { to: "ノイシュバンシュタイン城",
                                from: "ミュンヘン",
                                date: "2018-10-27",
                                time: "2時間",
                                detail: "ミュンヘンから急行電車に乗り、終点からバスに乗ります",
                                notice: "バイエルンチケットがあると安くいけます！",
                                picture: open("#{Rails.root}/public/images/dest12.jpg") }
                            ]
    },
    
    { user_id: 3,
      to: "新大阪駅",
      from: "道頓堀（グリコ）",
      date: "2016-09-16",
      time: "20分",
      outline: "みんな大好きグリコ",
      detail: "御堂筋線で一本でいけます",
      notice: "",
      reference: "",
      picture: open("#{Rails.root}/public/images/dest13.jpg")
    },
    
    { user_id: 3,
      to: "三崎港",
      from: "品川",
      date: "2019-08-13",
      time: "1時間20分",
      outline: "お手軽に綺麗な海へ",
      detail: "品川から京急線で一本です",
      notice: "みさきまぐろきっぷが超お得です！",
      reference: "https://www.keikyu.co.jp/visit/otoku/otoku_maguro/",
      picture: open("#{Rails.root}/public/images/dest14.jpg")
    },
    
    { user_id: 3,
      to: "バンコク",
      from: "東京",
      date: "2019-07-26〜2019-08-01",
      outline: "微笑みの国へ",
      reference: "https://www.thailandtravel.or.jp/areainfo/bangkok/",
      picture: open("#{Rails.root}/public/images/dest15.jpg"),
      schedules_attributes: [
                              { to: "ワットポー",
                                from: "ワットアルン",
                                date: "2020-07-29",
                                time: "30分",
                                detail: "川を挟んで対岸にあるので、船で向かいます",
                                notice: "行列ができていますが、そこまで待つことなく乗れます",
                                picture: open("#{Rails.root}/public/images/dest16.jpg") }
                            ]
    },
    
    { user_id: 3,
      to: "台湾",
      from: "東京",
      date: "2019-02-08〜2019-02-11",
      outline: "",
      reference: "",
      picture: open("#{Rails.root}/public/images/dest17.jpg"),
      schedules_attributes: [
                              { to: "九份",
                                from: "台北",
                                date: "2020-02-09",
                                time: "1時間",
                                detail: "直行バスが台湾中央駅から出ています",
                                notice: "",
                                picture: open("#{Rails.root}/public/images/dest18.jpg") }
                            ]
    }
  ]
)


user1 = User.find(1)
user2 = User.find(2)
user3 = User.find(3)

destination1 = Destination.find(1)
destination3 = Destination.find(3)
destination5 = Destination.find(5)
destination7 = Destination.find(7)
destination9 = Destination.find(9)
destination11 = Destination.find(11)

#follow
user1.follow(user2)
user1.follow(user3)
user2.follow(user1)
user2.follow(user3)
user3.follow(user1)
user3.follow(user2)

#favorite
user1.favorite(destination5)
user1.favorite(destination7)
user2.favorite(destination9)
user2.favorite(destination11)
user3.favorite(destination1)
user3.favorite(destination3)

#comment
destination11.comments.create(user_id: user1.id, content: '参考になりました')
destination11.comments.create(user_id: user1.id, content: '私も行きたいです')
destination11.comments.create(user_id: user2.id, content: '料金はいくらくらいでしたか？')
destination11.comments.create(user_id: user2.id, content: '途中に観光スポットはありますか？')

destination9.comments.create(user_id: user1.id, content: '参考になりました')
destination9.comments.create(user_id: user1.id, content: '私も行きたいです')
destination9.comments.create(user_id: user2.id, content: '料金はいくらくらいでしたか？')
destination9.comments.create(user_id: user2.id, content: '途中に観光スポットはありますか？')

#notification
user1.notifications.create(user_id: user1.id, destination_id: destination1.id,
                          from_user_id: user2.id, variety: 1)
user1.notifications.create(user_id: user1.id, destination_id: destination1.id,
                          from_user_id: user2.id, variety: 2, content: '参考になりました')
user1.notifications.create(follow_id: user1.id,
                          from_user_id: user2.id, variety: 3)                          

