//
//  MatchViewController.swift
//  PLREQ
//
//  Created by 이영준 on 2022/09/27.
//

import UIKit
import ShazamKit
import CoreLocation

class MatchViewController: UIViewController {
    
    //MARK: Variabales
    var recordedMusicList = [Music]() {
        didSet {
            self.noRecordedMusicLabel.isHidden = self.recordedMusicList.isEmpty ? false : true
        }
    }
    // 임시 Image URL 추가
    var recordedMusic = Music(title: "", artist: "", musicImageURL: URL(string: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjnXzicNWJkBNWVgLZpKUpMo7fk5-VSo94bq0MY5cjEOlVUG5DhLTN5AA1qT10glFjBFnok364lIzwNfTWCcGutM7Py9NCoHqld9lqRNt0mFBR3s7QG70fEoQxzR8dwX2bXAIbXmwPGLLMC4plLijz_iSvzqPTDYFor_c_gBtnFsS4XamcQyZAlCY9b/s320/PlreqDefaultImage.jpg")!)
    var viewModel: MatchViewModel?
    var isListening: Bool = false
    var timer: Timer?
    let playListViewController: PlayListViewController = {
        let storyBoard = UIStoryboard(name: "PlayListView", bundle: nil)
        guard let playListViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListView") as? PlayListViewController else { return UIViewController() as! PlayListViewController }
        return playListViewController
    }()
    let locationManager = CLLocationManager()
    var currentTime: String = ""
    var currentLocation: String = ""
    var savedLocation: String = ""
    var currentLatitude: CLLocationDegrees = 0.0
    var currentLongtitude: CLLocationDegrees = 0.0
    let userDefaults = UserDefaults.standard
    
    //MARK: IBOutlet Variable
    @IBOutlet weak var playListButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var matchMusicCollectionView: UICollectionView!
    @IBOutlet weak var noRecordedMusicLabel: UILabel!
    
    //MARK: IBOutlet Function
    @IBAction func tapRecordButton(_ sender: UIButton) {
        self.isListening.toggle()
        if self.isListening {
            // 음악 매칭 시 Display 가 꺼지지 않도록 구현
            UIApplication.shared.isIdleTimerDisabled = true
            // 30초 동안 한번씩 songSearch 함수 실행
            self.locationManager.requestLocation()
            timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: true)
        } else {
            UIApplication.shared.isIdleTimerDisabled = false
            timer?.invalidate()
            if self.recordedMusicList.count == 0 {
                self.isEmptyRecordedMusicListAlert()
            } else {
                self.saveRecordedMusicList()
            }
        }
    }
    
    @IBAction func tapPlayListButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(self.playListViewController, animated: true)
    }
    
    @objc func catchMusic() {
        do {
            try self.viewModel?.songSearch()
        } catch {
            print("error")
        }
    }
    
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleFunction()
        self.getUserDefaultsPlayList()
        
        if self.recordedMusicList.isEmpty {
            return
        } else {
            self.matchMusicCollectionView.reloadData()
            self.reactivateAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.viewModel == nil {
            self.viewModel = MatchViewModel(matchHandler: songMatched)
        }
    }
    
    //MARK: Style Function
    private func styleFunction() {
        self.configureCollectionView()
        self.configureLocationManager()
        self.configureNoRecordedMusicLabel()
    }
    
    private func configureCollectionView() {
        self.view.backgroundColor = .black
        self.matchMusicCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.matchMusicCollectionView.backgroundColor = UIColor.black
        self.matchMusicCollectionView.delegate = self
        self.matchMusicCollectionView.dataSource = self
    }
    
    private func configureLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureNoRecordedMusicLabel() {
        self.noRecordedMusicLabel.text = "하단의 버튼을 눌러 음악을 찾아보세요."
        self.noRecordedMusicLabel.textColor = .white
        self.noRecordedMusicLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    //MARK: Shazam Function
    private func songMatched(item: SHMatchedMediaItem?, error: Error?) {
        if error != nil {
            self.viewModel?.status = false
        } else {
            self.viewModel?.status = true
            
            // 동일한 타이틀, 아티스트의 음악이 이미 배열에 있는 경우 추가하지 않고 함수 종료
            for music in recordedMusicList {
                if music.title == item?.title && music.artist == item?.artist {
                    return
                }
            }
            self.viewModel?.title = item?.title
            self.viewModel?.artist = item?.artist
            self.viewModel?.musicImageURL = item?.artworkURL
            self.viewDraw()
        }
    }
    
    private func viewDraw() {
        self.recordedMusic.title = self.viewModel?.title ?? ""
        self.recordedMusic.artist = self.viewModel?.artist ?? ""
        self.recordedMusic.musicImageURL = self.viewModel?.musicImageURL ?? URL(string: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjnXzicNWJkBNWVgLZpKUpMo7fk5-VSo94bq0MY5cjEOlVUG5DhLTN5AA1qT10glFjBFnok364lIzwNfTWCcGutM7Py9NCoHqld9lqRNt0mFBR3s7QG70fEoQxzR8dwX2bXAIbXmwPGLLMC4plLijz_iSvzqPTDYFor_c_gBtnFsS4XamcQyZAlCY9b/s320/PlreqDefaultImage.jpg")!
        
        self.recordedMusicList.insert(self.recordedMusic, at: 0)
        self.setUserDefaultsPlayList()
        self.matchMusicCollectionView.reloadData()
    }
    
    private func isEmptyRecordedMusicListAlert() {
        let alert = UIAlertController(title: "검색된 음악이 없습니다.", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true)
    }
    
    private func saveRecordedMusicList() {
        let alert = UIAlertController(title: "재생 목록 저장", message: nil, preferredStyle: .alert)
        
        let registerButton = UIAlertAction(title: "저장", style: .default, handler: { _ in
            guard let title = alert.textFields?[0].text else { return }
            if title == "" {
                let placeHolder = "\(self.currentLocation)에서의 " + "\(self.currentTime)"
                PLREQDataManager.shared.save(title: placeHolder, location: self.savedLocation, day: Date(), latitude: self.currentLatitude, longtitude: self.currentLongtitude, musics: self.recordedMusicList)
            } else {
                PLREQDataManager.shared.save(title: title, location: self.savedLocation, day: Date(), latitude: self.currentLatitude, longtitude: self.currentLongtitude, musics: self.recordedMusicList)
            }
            self.recordedMusicList = [Music]()
            self.setUserDefaultsPlayList()
            self.matchMusicCollectionView.reloadData()
            self.navigationController?.pushViewController(self.playListViewController, animated: true)
        })
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        })
                                         
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            self.currentTimeFormatter(.now)
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                textField.placeholder = "\(self.currentLocation)에서의 " + "\(self.currentTime)"
            case .denied, .notDetermined, .restricted:
                textField.placeholder = ""
            default:
                textField.placeholder = ""
            }
        })
        self.present(alert, animated: true)
    }
    
    private func reactivateAlert() {
        let alert = UIAlertController(title: "이전에 기록해놓은 음악이에요", message: "계속해서 음악을 기록할까요?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "남기기", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let rebase = UIAlertAction(title: "비우기", style: .cancel) { _ in
            self.recordedMusicList = [Music]()
            self.matchMusicCollectionView.reloadData()
            self.setUserDefaultsPlayList()
        }
        [confirm, rebase].forEach(alert.addAction(_:))
        
        self.present(alert, animated: true)
    }
    
    private func setUserDefaultsPlayList() {
        do {
            try userDefaults.setObject(self.recordedMusicList, forKey: "LoadedPlayList")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getUserDefaultsPlayList() {
        do {
            try self.recordedMusicList = userDefaults.getObject(forKey: "LoadedPlayList", castTo: [Music].self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func currentTimeFormatter(_ date: Date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let currentHour: String = timeFormatter.string(from: date)
        
        if Int(currentHour) ?? 0 < 6 {
            self.currentTime = "시원한 새벽"
        } else if Int(currentHour) ?? 0 < 12 {
            self.currentTime = "산뜻한 아침"
        } else if Int(currentHour) ?? 0 < 18 {
            self.currentTime = "나른한 오후"
        } else {
            self.currentTime = "적적한 저녁"
        }
    }
}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordedMusicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.matchMusicCollectionView.dequeueReusableCell(withReuseIdentifier: "MatchMusicCell", for: indexPath) as? MatchMusicCell else { return UICollectionViewCell() }
        let music = self.recordedMusicList[indexPath.row]
        cell.musicTitle.text = music.title
        cell.musicArtist.text = music.artist
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: music.musicImageURL)
            DispatchQueue.main.async {
                cell.musicImage.image = UIImage(data: data!)
            }
        }
        cell.musicImage.addMusicCellGradient(imageView: cell.musicImage)
        return cell
    }
}

extension MatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MatchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var locality = ""
            var subLocality = ""
            var thoroughfare = ""
            self.currentLatitude = location.coordinate.latitude
            self.currentLongtitude = location.coordinate.longitude
            
            let findLocation = CLLocation(latitude: self.currentLatitude, longitude: self.currentLongtitude)
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [weak self] (place, error) in
                if let address: [CLPlacemark] = place {
                    locality = "\(address.last?.locality ?? "")"
                    subLocality = "\(address.last?.subLocality ?? "")"
                    thoroughfare = "\(address.last?.thoroughfare ?? "")"
                    self?.savedLocation = "\(locality) \(subLocality)"
                    self?.currentLocation = "\(locality) \(thoroughfare)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}
