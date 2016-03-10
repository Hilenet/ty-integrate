require 'pg'

class Db
=begin
  table/'paterns'
  
   key  |  res   
  ------+--------
        |
        |
=end
  
  def initialize targets
    # @db_infoを他で使わないようなら書き直すべき
    @db_info = {host: targets["host"], user: targets["user"], 
      pass: targets["pass"], db: targets["db"], port: targets["port"]
    }
    
    @connect = PG::connect(host: @db_info[:host], user: @db_info[:user], 
      password: @db_info[:pass], dbname: @db_info[:db], port: @db_info[:port]) 
    
  end

  def date  #=> string date
    # to use test
    @connect.exec("SELECT current_date hoge").values.first
  end

  def show #=> string array
    res = @connect.exec("SELECT * FROM paterns").values
    if(res.empty?)
      puts "the table is empty"
      return ["NO DATA"]
    end
    res
  end

  def search key #=> string res
    # use place_holder to measure for SQL_ingection
    res = @connect.exec_params("SELECT res FROM paterns WHERE key = $1", [key]).values
    
    unless res.empty?
      return res[0][0]
    end
    return ""
  end
  
  def delete key #=> boolean result
    res = search(key)
    
    if res.empty?
      puts "the key is not exist"
      return false
    end
    
    @connect.exec_params("DELETE FROM paterns WHERE key = $1", [key])
    puts "delete data set (#{key}, #{res})"
    return true
  end
  
  def insert key, res #=> boolean result
    unless search(key).empty?
      puts "the set has existed"
      return false
    end
    
    @connect.exec_params("INSERT INTO paterns VALUES ($1, $2)", [key, res]).values
    puts "success"
    return true
  end

  def get_connect #=>PG::connection
    @connect
  end

  def event tweet #=>string res
    # key一覧を取得
    list = @connect.exec("SELECT key FROM paterns").values
    
    list[1].each do |key|
      if tweet.include? key
        return search(key)
      end
    end
    
    puts "nothing"
    
    return ""
  end

  def list #=> array key
    @connect.exec("SELECT key FROM paterns").values
  end


end


__END__


