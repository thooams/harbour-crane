class Image::ConvertImage
  include ActiveModel

  attr_accessor :id, :names, :name, :tag, :size, :created_at

  def initialize image
    @id         = without_hashing_method(image.id)
    @info       = image.info
    @names      = get_names
    @name       = get_name
    @tag        = get_tag
    @size       = get_size
    @created_at = get_date_time
  end

  def attributes
    { id: @id, names: @names, name: @name, tag: @tag, size: @size, created_at: @created_at }
  end

  private

  def get_date_time
    Time.at(@info['Created']).strftime(HarbourCrane::Application::TIME_FORMAT) unless @info['Created']
  end

  def without_hashing_method str
    str.split(':').last
  end

  def get_name
    @info['RepoTags'].first.split(':').first unless @info['RepoTags'].blank?
  end

  def get_tag
    @info['RepoTags'].first.split(':').last unless @info['RepoTags'].blank?
  end

  def get_names
    @info['RepoTags'] || []
  end

  def get_size
    @info['VirtualSize']
  end

end
