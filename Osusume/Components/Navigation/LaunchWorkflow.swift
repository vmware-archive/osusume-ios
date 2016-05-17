struct LaunchWorkflow {
    let router: Router
    let sessionRepo: SessionRepo
    let photoRepo: PhotoRepo

    init (router: Router, sessionRepo: SessionRepo, photoRepo: PhotoRepo) {
        self.router = router
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
    }

    func startWorkflow() {
        if let _ = sessionRepo.getToken() {
            router.showRestaurantListScreen()
        } else {
            router.showLoginScreen()
        }
    }
}
