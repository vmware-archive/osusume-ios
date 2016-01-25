class LaunchWorkflow {
    let sessionRepo: SessionRepo

    init (sessionRepo: SessionRepo) {
        self.sessionRepo = sessionRepo
    }

    func startWorkflow(router: Router) {
        router.showRestaurantListScreen()
    }
}