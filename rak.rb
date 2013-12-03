require 'capybara/dsl'
require 'spreadsheet'

Capybara.run_server = false
Capybara.default_driver = :selenium
Capybara.default_selector = :xpath

class Rakuten
	include Capybara::DSL

	def go                                                   
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet
		red = 0
		paginatori = ["http://global.rakuten.com/en/search/?f=2&k=&p=2&sid=crouka",
					        "http://global.rakuten.com/en/search/?f=2&k=&p=3&sid=crouka",
					        "http://global.rakuten.com/en/search/?f=2&k=&p=4&sid=crouka"]
		paginatori.each do |pag|
			visit pag 			        

			ime_linka = []
			all(:xpath, '//div[@class="b-content b-fix-2lines"]/a').each do |link|         
				ime_linka << link[:href]                                                   
			end

			ime_linka.each do |link|
				visit link

			 	if page.has_selector?(:xpath, '//*[@itemprop="name"]')
					sheet[red,0] = find(:xpath, '//*[@itemprop="name"]').text
				end
				if page.has_selector?(:xpath, '//*[@itemprop="price"]')
					sheet[red,1] = find(:xpath, '//*[@itemprop="price"]').text
			  end
				if page.has_selector?(:xpath, '//*[@class="b-product-label b-color-safe"]/div')
					sheet[red,2] = find(:xpath, '//*[@class="b-product-label b-color-safe"]/div').text
				end
				if page.has_selector?(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[1]/div/ul')  
					sheet[red,3] = find(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[1]/div/ul').text
				end
				if page.has_selector?(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[2]/div/ul')  
					sheet[red,4] = find(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[2]/div/ul').text
				end
				if page.has_selector?(:xpath, '//span[@class="country"]')
					sheet[red,5] = find(:xpath, '//span[@class="country"]').text
				end 
				if page.has_selector?(:xpath, '//span[@class="fabric"]')
					sheet[red,6] = find(:xpath, '//span[@class="fabric"]').text
				end

				red +=1
			end
		end
		book.write "rak.xls"
	end
end
a = Rakuten.new
a.go