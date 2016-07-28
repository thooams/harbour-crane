# Harbour Crane
Manage you apps through Docker containers.

![habour crane](https://raw.githubusercontent.com/thooams/harbour-crane/master/app/assets/images/harbour-crane.png)


# Install

```
  docker pull thooams/harbour-crane
```

# Initialize

```
  rails db:create
```

```
  rails db:migrate
```

```
  rails nginx:create
```


# Ustart

Upstart must do with harbour-crane

* docker-compose run web rake apps:relaunch (to relaunch all apps ran previously)
* docker-compose up -d

