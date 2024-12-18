# OSMS(Operator Safety Management System)
<img src="">

## 소개
OSMS은 작업자가 장비에 접근 시 iOS 앱 Push 알림, LED, Buzzer를 통해 안전 경각심을 높이는 시스템입니다.

## 개발 기간
- 2022/02/01 ~ 2022/06/14

## 개발 환경
- IDE : Xcode12, Arduino IDE
- Editor : VSCode
- OS : macOS 11.0.1
- Language : Swift, C, JavaScript
- Local Server : Node.js
- Server Side Framework : Express
- DB : MariaDB
- Arduino : Arduino Uno, Arduino Nano 33 BLE, XBee S2C, HC-SR501, GEC-23C, LED
- Library
    - [iOS] UIKit, Alamofire, CoreBluetooth
    - [Arduino] SoftwareSerial, Xbee, Arduino BLE
- Tool : Fritzing, Draw.io
- Cooperation : Notion, Slack

## 시스템 아키텍처
<img src="">
### 1. 사용자 식별
- **BLE, Zigbee** 통신을 통해 사용자 데이터셋**[작업장-Devie Token]**을 서버로 전송
  ⇒ 사용자가 어느 작업장에 있는 지 식별 ex) **작업장 A-김혜진**

### 2. 센서값 전송
 - **BLE, Zigbee** 통신을 통해 인체감지센서값**[작업장-센서-번호-감지여부]**을 서버로 전송
   
### 3. iOS 앱 알림 및 LED와 Buzzer ON
- 작업자가 __장비에 가까이 접근__했을 때 **iOS 앱 알림, LED & Buzzer ON**
