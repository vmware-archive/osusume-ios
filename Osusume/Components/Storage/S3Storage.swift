protocol RemoteStorage {
    func uploadFile(withUrl url: NSURL) -> String
}

struct S3Storage: RemoteStorage {

    func uploadFile(withUrl url: NSURL) -> String {
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: AWSRegionType.APNortheast1,
            identityPoolId: "ap-northeast-1:f65d8e6f-ac25-46b1-8106-f72026005681"
        )

        let configuration = AWSServiceConfiguration(
            region: AWSRegionType.APNortheast1,
            credentialsProvider: credentialsProvider
        )

        let serviceManager = AWSServiceManager.defaultServiceManager()
        serviceManager.defaultServiceConfiguration = configuration

        let key = url.lastPathComponent!
        let bucketName = "osusume-tokyo-dev"
        let s3 = AWSS3TransferManager.defaultS3TransferManager()

        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "osusume-tokyo-dev"
        uploadRequest.key = key
        uploadRequest.body = url
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead

        s3.upload(uploadRequest)

        return "https://s3-ap-northeast-1.amazonaws.com/\(bucketName)/\(key)"
    }
}
