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
      system("wget https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl -O #{ HarbourCrane::Application::PROXY_DIR }/templates/nginx.tmpl")
      system("cp #{ HarbourCrane::Application::PROXY_DIR }/templates/nginx.tmpl #{ HarbourCrane::Application::PROXY_DIR }/templates/nginx-1.tmpl")
      system("touch #{ HarbourCrane::Application::PROXY_DIR }/default.conf")

       self.where({
        name:         HarbourCrane::Application::PROXY_NAME,
        description:  'NGINX is running as a HTTP(S) proxy, with automated configuration from Docker',
        author:       'Thomas HUMMEL',
        ports:        '80:80;443:443',
        image:        HarbourCrane::Application::PROXY_IMAGE_NAME,
        category:     :proxy,
        virtual_host: 'localhost',
        volumes:      [
          "/var/run/docker.sock:/tmp/docker.sock:ro",
          "#{ HarbourCrane::Application::PROXY_DIR }/default.conf:/etc/nginx/conf.d/default.conf:ro",
          "#{ HarbourCrane::Application::PROXY_DIR }/templates/nginx.tmpl:/app/nginx.tmpl:ro",
          "#{ HarbourCrane::Application::PROXY_DIR }/ssl:/etc/nginx/certs:ro"
        ].join(';')
      }).first_or_create!
    end
  end
end
