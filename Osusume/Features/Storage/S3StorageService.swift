protocol RemoteStorage {
    func uploadFile(withUrl url: NSURL) -> String
}

struct S3Storage: RemoteStorage {

    func uploadFile(withUrl url: NSURL) -> String {

        configureCredentials()

        let key = "user_id/\(url.lastPathComponent!)"
        let bucketName = "osusume-tokyo-dev"

        let s3 = AWSS3TransferManager.defaultS3TransferManager()
        let uploadRequest = AWSS3TransferManagerUploadRequest()

        uploadRequest.bucket = bucketName
        uploadRequest.key = key
        uploadRequest.body = url
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead

        s3.upload(uploadRequest)

        return "https://s3-ap-northeast-1.amazonaws.com/\(bucketName)/\(key)"
    }

    private func configureCredentials() {
        let identityPoolId = "ap-northeast-1:f65d8e6f-ac25-46b1-8106-f72026005681"
        let regionType = AWSRegionType.APNortheast1

        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: regionType,
            identityPoolId: identityPoolId
        )

        let configuration = AWSServiceConfiguration(
            region: regionType,
            credentialsProvider: credentialsProvider
        )

        AWSServiceManager
            .defaultServiceManager()
            .defaultServiceConfiguration = configuration
    }

}
