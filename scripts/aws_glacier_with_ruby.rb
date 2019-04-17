# gem install fog #fog-2.1.0
# S3 to Glacier: https://aws.amazon.com/blogs/aws/archive-s3-to-glacier/

require 'fog'

settings = {
  region: '',
  aws_access_key_id: '',
  aws_secret_access_key: '',
  valult_name: '',
  multipart_chunk_size: 1024*1024,
  # path_to_file: '/Users/Udit/Movies/The.Interview.2014.BDRip.x264-SPARKS.mkv'
  path_to_file: '',
  output_file: ''
}

glacier = Fog::AWS::Glacier.new(aws_access_key_id: settings[:aws_access_key_id], aws_secret_access_key: settings[:aws_secret_access_key], region: settings[:region])

# If you need to create a new vault
# vault = glacier.vaults.create id: settings[:valult_name]

# Read existing vault
vault = glacier.vaults.get(settings[:valult_name])

# Upload archive to vault using Multipart upload. NOTE: AWS Glacier has a limit on maximum chunks for multipart. Choose the multipart_chunk_size accordingly
response = vault.archives.create body: File.read(settings[:path_to_file]), description: 'First glacier file', multipart_chunk_size: settings[:multipart_chunk_size]

# Write the id of archive to a text file
written_file = response.id
File.write(settings[:output_file], "#{settings[:path_to_file]} || #{response.id}")

# Reading the archives using job. NOTE: Job can take 3-12 hours to process.
result = vault.jobs.create(:type => Fog::AWS::Glacier::Job::ARCHIVE, :archive_id => 'UvArTMZZeUw0zmRsTddj-GUENjpp_q0tc7QLt9uBVnwpApz2Ipu-5n4GT-SNVn50VLZAd6RCLfWQLe3WmF8VSVLK0aT0LXZB0Qv3PqKspGwOO8WtFC68FhWeilBKK70wtdaKegXKiQ' )
