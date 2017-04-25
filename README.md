# hello-monitoring [![Build Status](https://travis-ci.org/arpinum-oss/hello-monitoring.svg?branch=master)](https://travis-ci.org/arpinum-oss/hello-monitoring)

> Quis custodiet ipsos custodes?
> <cite>(Decimus Iunius Iuvenalis)</cite>

**Hello Monitoring** is a simple and stupid monitoring service powered by Docker and Bash.

It is built from an Alpine image. It uses crond to send GET request via cURL periodically, then it analyses the response and finally send you a notification.

## Quick start

```
docker pull arpinum/hello-monitoring
docker run -e URL="https://google.com" -e EXPECTED_RESPONSE="Google" -ti hello-monitoring:latest
```

## Docker compose example

The example folder contains a simple [docker-compose.yml](example/docker-compose.yml) example which describes a fake web app and an **Hello Monitoring** instance.

## External notification services

The only supported service is Slack at the moment.
Just set the *SLACK_WEBHOOK_URL* variable to send notifications via your previously configured [incoming webhook](https://my.slack.com/services/new/incoming-webhook/).

## Configuration

All configuration is done via environment variables:

| Variable | Description |
| --- | --- | 
| CRON | cron expression to use with crond. Default is * * * * * (every minutes). |
| URL | A GET request will be sent to the URL. This is **mandatory**. |
| EXPECTED_RESPONSE | Regex that will test the GET response. This is **mandatory**. |
| NAME | Name of the service to monitor. Default is the truncated URL. |
| NOTIFY_ON_SUCCESS | Success messages will be sent to external notification services. yes or no. Default is *no*. |
| NOTIFY_ON_ERROR | Error messages will be sent to external notification services. yes or no. Default is *no*. |
| NOTIFY_ON_CHANGE | Messages will be sent to external notification services when status change (e.g. error to success or conversely). yes or no. Default is *yes*.|
| SLACK_WEBHOOK_URL | If present, notifications will be sent to this webhook. |

## FAQ

#### How can i monitor multiple services ?

Just start multiple containers with different configurations.

#### But, I already have 13 micro services :/

You now have 26 micro services :) An architecture to be proud of.

#### How can i send notifications via email, messenger, icq, or fax ?

You cannot. **Hello Monitoring** is a dumb service.

## License

[MIT](LICENSE)

