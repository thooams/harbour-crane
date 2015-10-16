desc "Create App server Nginx"
task nginx: :environment do
  id   = "8709f9ec7fc18331549f"

  @app = App.find(id)

  if @app.nil?
    @app = App.new({
      id:           id,
      name:         'Nginx Server',
      description:  'NGINX is running as a HTTP(S) proxy, with automated configuration from Docker',
      author:       'Thomas HUMMEL',
      ports:        '80:80;443:443',
      image:        'jwilder/nginx-proxy',
      virtual_host: 'nginx',
      volumes:      '/var/run/docker.sock:/tmp/docker.sock:ro;/srv/docker/nginx/nginx.tmpl:/app/nginx.tmpl:ro;/etc/nginx/ssl:/etc/nginx/certs:ro'
    })

    @app.generate
  end

  @app.start
end

