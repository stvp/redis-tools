# usage: ruby bigkeys_resp.rb 100 | redis-cli --pipe

megabytes = ARGV[0].to_i

MEGABYTE = 1024 * 1024
BIG_VALUE = (0...MEGABYTE).map { (65 + rand(26)).chr }.join

# Taken from http://redis.io/topics/mass-insert
def gen_redis_proto(*cmd)
    proto = ""
    proto << "*"+cmd.length.to_s+"\r\n"
    cmd.each{|arg|
        proto << "$"+arg.to_s.bytesize.to_s+"\r\n"
        proto << arg.to_s+"\r\n"
    }
    proto
end

(0...megabytes).each do |i|
  STDOUT.write( gen_redis_proto( "SET", "key#{i}", BIG_VALUE ) )
end

