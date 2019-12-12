# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せる
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
# - Integer
# - Numeric
# - Class
# - Hash
# - TrueClass
module HogeModule
  def hoge
    "hoge"
  end
end

class String
  include HogeModule
end

class Integer
  include HogeModule
end

class Numeric
  include HogeModule
end

class Class
  include HogeModule
end

class Hash
  include HogeModule
end

class TrueClass
  include HogeModule
end
