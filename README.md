# Github notifications

## Screenshots

### Fenix 3
![Screenshot](https://github.com/eternal-flame-AD/git-notifications-ciq/blob/master/docs/img/git-notification-fenix3.png?raw=true)
### Forerunner 630
![Screenshot](https://github.com/eternal-flame-AD/git-notifications-ciq/blob/master/docs/img/git-notification-fr630.png?raw=true)
![Screenshot](https://github.com/eternal-flame-AD/git-notifications-ciq/blob/master/docs/img/git-notification-menu.png?raw=true)

## Features

- Notifications count

- Abbreviated notification type, source repo, and title

- Mark all as read

- Open notifications on your phone

## Known Limitations

- Due to the response body size limit by the Connect IQ SDK, only around 3-4 notifications could be received correctly. If the API response body size exceeded the limit, a "++" and an error message will appear indicating that there is too much notifications to be received from the GitHub API. My solution is to build an API gateway for the GitHub side which removed unneccesary fields from the API response and I think we would be able to receive at least 20 notifications then. This will be implemented in the future and the gateway feature will ONLY be used with the user's explicit consent in application settings. Also, the source code of the gateway would be publicized also and I would provide a way for users to build their own gateway on their own server and domains so that there would be no worries on the credential safety.

## TODO

- Add OAuth support

- Add If-Modified-After support

- (Maybe) Add GitLab support

## Disclaimer

- This Connect IQ(R) App is a personal project developed and open-sourced by [eternal-flame-AD](https://github.com/eternal-flame-AD). The application is neither affiliated to nor endorsed by GitHub, Inc. The application only sends requests to the already Github API publicized by GitHub, Inc. The use of the GitHub logo is only for the indication of GitHub notification count.

## LICENSE 

- This project is released and open-sourced on GitHub under the Apache License 2.0. You should receive a copy of the license together with the source code. If not, get it [here](https://github.com/eternal-flame-AD/git-notifications-ciq/blob/master/LICENSE).