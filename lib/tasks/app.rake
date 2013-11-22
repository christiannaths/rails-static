require "fileutils"

namespace :app do
  desc "Generate static pages"
  task static: [:my_pages]

  desc "Generates static pages"
  task my_pages: :environment do
    pages = {
        # TODO:
        '' => 'index.html',
        'sample' => 'sample/index.html',
        'sample' => 'sample/other/deep/nested/index.html',
    }
    app = ActionDispatch::Integration::Session.new(Rails.application)

    pages.each do |route, output|
        puts "Generating #{output}..."

        outpath = File.join ([Rails.root, 'public', output])
        outdir = outpath.split('/')[0..-2].join('/')
        FileUtils::mkdir_p outdir

        resp = app.get(route)
        if resp == 200
            FileUtils::rm outpath if File.exists?(outpath)
            File.open(outpath, 'w') do |f|
                f.write(app.response.body)
            end
        else
            puts "Error generating #{output}!"
        end
    end
  end
end
