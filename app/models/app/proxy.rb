module App::Proxy
  extend ActiveSupport::Concern

  included do
    def proxy?
      slug == HarbourCrane::Application::PROXY_NAME.parameterize
    end

    def self.proxy_exist?
      !App.all.select{ |app| app.proxy? }.empty?
    end

    def self.destroy_proxy
      proxy_app = App.find_by_name(HarbourCrane::Application::PROXY_NAME)
      proxy_app.destroy
    end

    def self.create_and_start_proxy
      proxy_app = create_proxy
      proxy_app.start
    end

    def self.create_proxy
      ## Add current nginx.tmpl to ~/harbour-crane/proxy/nginx.tmpl
      system("wget https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl -O #{ HarbourCrane::Application::PROXY_DIR }/nginx.tmpl")

      self.where({
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
    end
  end
end
