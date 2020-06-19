# All the Redis functionality is now available across the entire app through the ‘$redis’ global.
# Here’s an example of how to access the values in the redis server (fire up a Rails console):
# $redis.set("test_key", "Hello World!")
# To fetch this value, just do:
# $redis.get("test_key")
$redis = Redis::Namespace.new(env["APPLICATION_NAME"], :redis => Redis.new)