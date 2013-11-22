StaticSiteGenerator::Application.routes.draw do
  get "sample", to: "static#sample"
  root 'static#home'
end
