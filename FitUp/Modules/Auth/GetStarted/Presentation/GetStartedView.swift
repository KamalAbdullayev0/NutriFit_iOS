import UIKit

class GetStartedController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private let viewModel: GetStartedViewModel
    private let pageViewController: UIPageViewController
    
    private let texts = [
        "\"Fuel Your Body, Find Your Balance\" Discover personalized keto diets and health calculators tailored to your goals. Whether it's body fat, metabolism, or calorie intake NutriFit guides you every step of the way to a healthier, more balanced you",
        
        "\"Move More, Explore Better\" Find nearby sports salons and fitness centers with just a tap! NutriFit's smart map ensures you stay active and reach your fitness goals, no matter where you are.",
        
        "\"Your Health, Our Chatbot's Mission\" Got questions? NutriFit's AI-powered chatbot is here to support you 24/7 with personalized answers to keep your health journey on track. Ask away, and let the transformation begin!"
    ]
    
    private var currentIndex = 0
    private var timer: Timer?
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let logotextView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yazi")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var signUpButton = CustomButtonAuth(
        title: "Login",
        height: 60,
        textColor: .white,
        backgroundColor: Resources.Colors.orange,
        font: Resources.AppFont.medium.withSize(20),
        cornerRadius: 16
    ) {
        [weak self] in
        self?.viewModel.didTapLogin()
        print("basdun")
    }
    lazy var registerButton = CustomButtonAuth(
        title: "Register",
        height: 60,
        textColor: .white,
        backgroundColor: Resources.Colors.green,
        font: Resources.AppFont.medium.withSize(20),
        cornerRadius: 16
    ) {[weak self] in
        self?.viewModel.didTapRegister()
        print("Basdunn")
    }
    
    init(viewModel: GetStartedViewModel) {
        self.viewModel = viewModel
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.background
        setupUI()
        startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    private func setupUI() {
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            if let firstVC = createTextViewController(for: currentIndex) {
                pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
            }
            
            addChild(pageViewController)
            view.addSubview(pageViewController.view)
            view.addSubview(logoImageView)
            view.addSubview(logotextView)
            view.addSubview(signUpButton)
            view.addSubview(registerButton)
            view.addSubview(pageControl)
            
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            pageViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 180),
                logoImageView.widthAnchor.constraint(equalToConstant: 180),
                logoImageView.heightAnchor.constraint(equalToConstant: 180),
                
                logotextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logotextView.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 64),
                logotextView.widthAnchor.constraint(equalToConstant: 280),
                logotextView.heightAnchor.constraint(equalToConstant: 56),
                
                pageViewController.view.topAnchor.constraint(equalTo: logotextView.bottomAnchor, constant: 40),
                pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                pageViewController.view.heightAnchor.constraint(equalToConstant: 120),
                
                pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 20),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
                signUpButton.heightAnchor.constraint(equalToConstant: 70),
                
                registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                registerButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15),
                registerButton.heightAnchor.constraint(equalToConstant: 70)
            ])
        }
        
        private func createTextViewController(for index: Int) -> TextPageViewController? {
            guard index >= 0 && index < texts.count else { return nil }
            let textVC = TextPageViewController(index: index)
            textVC.setText(texts[index])
            return textVC
        }
        
        private func startAutoScroll() {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                self?.goToNextPage()
            }
        }
        
        private func stopAutoScroll() {
            timer?.invalidate()
            timer = nil
        }
        
        private func goToNextPage() {
            currentIndex = (currentIndex + 1) % texts.count
            if let nextVC = createTextViewController(for: currentIndex) {
                pageViewController.setViewControllers([nextVC], direction: .forward, animated: true)
                pageControl.currentPage = currentIndex
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let currentVC = viewController as? TextPageViewController else { return nil }
            let previousIndex = currentVC.index - 1
            return previousIndex >= 0 ? createTextViewController(for: previousIndex) : nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentVC = viewController as? TextPageViewController else { return nil }
            let nextIndex = currentVC.index + 1
            return nextIndex < texts.count ? createTextViewController(for: nextIndex) : nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let currentVC = pageViewController.viewControllers?.first as? TextPageViewController {
                currentIndex = currentVC.index
                pageControl.currentPage = currentIndex
            }
        }
    }

    private class TextPageViewController: UIViewController {
        let index: Int
        private let label = UILabel()
        
        init(index: Int) {
            self.index = index
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setText(_ text: String) {
            label.text = text
            label.font = Resources.AppFont.medium.withSize(14)
            label.textColor = .black
            label.numberOfLines = 0
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            view.backgroundColor = .clear
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
