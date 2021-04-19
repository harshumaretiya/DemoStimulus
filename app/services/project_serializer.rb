class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :name, :description

end
