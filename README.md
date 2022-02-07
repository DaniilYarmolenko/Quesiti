# Quesiti
Quesiti - проект курса по iOS от VK Group. Современная реинкарнация ask.fm 


## Что нужно сделать, чтобы заработал проект
1. Добавить в AppDelegate ключи от [облачных сервисов Google](https://console.cloud.google.com/google/maps-apis/start) для работы с картами.
```swift
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("")
        GMSPlacesClient.provideAPIKey("")
        // Override point for customization after application launch.
        return true
    }
```

2. Создать проект в Firebase и скачать файл [GoogleService-Info.plist](https://firebase.google.com)
## Основной функционал приложения
Задачи, решаемые данным приложением описаны в [презентации](https://github.com/DaniilYarmolenko/Quesiti/blob/5a368c2e3ca8a849af6c5a2a80e7ff48b0b21d56/%D0%9F%D1%80%D0%B5%D0%B7%D0%B5%D0%BD%D1%82%D0%B0%D1%86%D0%B8%D1%8F%20Quesiti.key).

Проект на стадии доработки


## License
[MIT](https://choosealicense.com/licenses/mit/)
