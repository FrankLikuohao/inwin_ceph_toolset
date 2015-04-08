import boto
import boto.s3.connection
access_key = 'DUC9VUKQFF9SVEOL2QEE'
secret_key = '45nz4DrDmvWdQlIJ1Bf+NvmphXSDL7J7w+Kfo6I5'
conn = boto.connect_s3(
aws_access_key_id = access_key,
aws_secret_access_key = secret_key,
host = '{vmon1}',
is_secure=False,
calling_format = boto.s3.connection.OrdinaryCallingFormat(),
)
bucket = conn.create_bucket('my-new-bucket')
for bucket in conn.get_all_buckets():
        print "{name}\t{created}".format(
                name = bucket.name,
                created = bucket.creation_date,
)
