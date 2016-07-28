namespace :nginx do
  desc "Create App server Nginx and start"
  task create: :environment do

    @app = App.where({
      name:         HarbourCrane::Application::PROXY_NAME,
      description:  'NGINX is running as a HTTP(S) proxy, with automated configuration from Docker',
      author:       'Thomas HUMMEL',
      ports:        '80:80;443:443',
      image:        'jwilder/nginx-proxy',
      virtual_host: 'nginx',
      category:     :proxy,
      volumes:      [
        "/var/run/docker.sock:/tmp/docker.sock:ro",
        "#{ HarbourCrane::Application::PROXY_DIR }/nginx.tmpl:/app/nginx.tmpl:ro",
        "#{ HarbourCrane::Application::PROXY_DIR }/ssl:/etc/nginx/certs:ro"
      ].join(';')
    }).first_or_create!

    @app.start
  end

  desc "Destroy App server Nginx and compose file"
  task destroy: :environment do

    @app = App.find_by_name(HarbourCrane::Application::PROXY_NAME)
    @app.destroy
  end
end
