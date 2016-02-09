class S3PhotoRepo : PhotoRepo {
    static let regionType = AWSRegionType.APNortheast1
    static let identityPoolId = "ap-northeast-1:f65d8e6f-ac25-46b1-8106-f72026005681"

    func configureCredentials() {
        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: S3PhotoRepo.regionType, identityPoolId: S3PhotoRepo.identityPoolId)
        let configuration = AWSServiceConfiguration(region: S3PhotoRepo.regionType, credentialsProvider:credentialsProvider)

        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
}