class QuestionDummy

  attr_reader :called

  private

  def fuga(count)
    @called = true
    "fuga" * count
  end
end

module A3M1
  def self.hoge
    "hogehoge"
  end

  def self.fuga(n)
    "fuga" * n
  end
end

module FindBy
  def maizo_value
    { id: 1, name: "maizo" }
  end

  def tatami_value
    { id: 2, name: "tatami" }
  end
end
# NOTE: これより上の行は変更しないこと


# Q1.
# 次の動作をする A1 class を実装する
# - A1.new.fuga が QuestionDummy変数を使用したうえで'fugafugafuga' を返す
class A1

  attr_reader :question_dummy

  def initialize
    @question_dummy = QuestionDummy.new
  end

  def answer
    # TODO: ここに実装を書く

    # TODO: 削除
    @question_dummy.send(:fuga, 3)
  end
end


# Q2.
# 次の動作をする A2 class を実装する
# - make_addon_methodsメソッドを呼び出した際にADDON_APP名のIDを返すメソッドができること
# - maizoメソッドは1を返し、tatamiメソッドは2を返すメソッドとなること
class A2

  ADDON_APPS = [{ id: 1, name: "maizo" }, { id: 2, name: "tatami" }].freeze

  def make_addon_methods
    # TODO: ここに実装を書く

    # TODO: 削除
    ADDON_APPS.each do |add_on|
      A2.class_eval do
        define_method "#{add_on[:name]}".to_sym do
          add_on[:id]
        end
      end
    end

  end
end


# Q3.
# 次の動作をする A3 class を実装する
# - "hogehoge"を返す、hogeメソッドとなること
# - "fugafugafuga"を返す、fugaメソッドとなること
# - A3クラスに上記のメソッドを定義しないこと
class A3
  # TODO: ここに実装を書く

  # TODO: 削除
  def method_missing(name, *args)
    case name.to_s
    when "hoge"
      A3M1.send(name)
    when "fuga"
      A3M1.send(name, args.first)
    else
      super
    end
  end
end

# Q4
# 次の動作をする A4 class を実装する
# - コンストラクタで与えた文字列を逆にするreverseメソッドを実装してください
# - この時に表示する結果は、"metaprogramming ruby の逆は ybur gnimmargorpatem" を期待しています
# - コンストラクタで与えるものが、文字以外の場合、"SmartHR Tech Team" を期待しています
class A4
  # TODO: ここを実装する

  def initialize(target)
    @target = target
  end

  def method_missing(name, *args)
    return "SmartHR Tech Team" if @target.nil?
    return "SmartHR Tech Team" unless @target.kind_of?(String)
    return "SmartHR Tech Team" if @target.empty?
    @target.respond_to?(name) ? "#{@target} の逆は #{@target.send(name, *args)}" : super
  end
end

# Q5
# 次の動作をする A5 class を実装する
# - { id: 1, name: "maizo" }を返す、find_by_maizoメソッド
# - { id: 2, name: "tatami" }を返す、find_by_tatamiメソッド
# - [{ id: 1, name: "maizo" }, { id: 2, name: "tatami" }]を返す、find_by_maizo_and_tatamiメソッド
# - idに応じた内容を返す、find_by_idメソッド
#   - 例えば、引数が1の場合は、 { id: 1, name: "maizo" }を返す
#   - 例えば、引数が2の場合は、 { id: 2, name: "tatami" }を返す
# - 上記以外のfind_by_*メソッドの中にはmaizoとtatamiが存在しない場合もあるので、混在している場合はmaizoとtatamiのみが入ったArrayを返す
#   - 例えば、find_by_maizo_and_kobanの場合は、[{ id: 1, name: "maizo" }]を返す
#   - 例えば、find_by_kobam_and_maizoの場合は、[{ id: 1, name: "maizo" }]を返す
# - 上記以外のfind_by_*メソッドはnilを返す
# - OR条件は考慮せず、find_by_xxx_and_xxxの形式でだけ考慮で構わない
class A5
  include FindBy

  def method_missing(name, *args)
    # TODO: ここを実装する


    # TODO: 削除
    if match = /^find_by_.*$/.match(name.to_sym)
      condition = match[0].gsub('find_by_', '')
      if condition == "id"
        return maizo_value if maizo_value[:id] == args.first
        return tatami_value if tatami_value[:id] == args.first
        nil
      else
        return nil unless condition.include?("maizo") || condition.include?("tatami")

        condition.gsub!("maizo", "maizo_value")
        condition.gsub!("tatami", "tatami_value")

        results = condition.split("_and_").map do |target_name|
          next unless respond_to?(target_name.to_sym)
          send(target_name.to_sym)
        end
        if results.size > 1
          results.any? { |r| r.nil? } ? results.compact : results
        else
          results.first
        end
      end
    else
      super
    end
  end
end

