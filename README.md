# Truckit iOS User Application#
```bash
Truck it iOS driver application setup required swift 4 and xcode 9 or above. 
```

## Project Setup

1. Clone the source code from bitbucket
```bash
git clone ----------
```
2. Open prroject root directory in terminal and run
```bash
pod install
```
3. Open workspace file in  Xcode.

4. Connect debugging device or open emulator iOS version <= 12

5. Run the project in xcode


	
## Deployment instructions
Push the updates to bitbucket and pull from development or production server

## Automatic Deployment
Login to [Codemagic](https://codemagic.io/start/) and select Truckit User iOS.
1. Click on start new build -> Select branch -> select the work flow -> then start new build

Code magic will automatically build and deploy the Android & iOS build release.
## Manual Deployment

1. In Xocde go to Window -> Organizer
2. Then select your app archive from archives
3. Then click the "Distribute App" button on right panel

Then follow the below steps
    a. Select method of distribution as iOS app store and click next
    b. Select a destination as export and click next
    c. Select automatically manage signing and click next
    d. Review the selected options and start export to selected location
    

