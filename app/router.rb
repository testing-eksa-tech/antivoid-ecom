require 'erb'
require 'json'
require 'csv'
require_relative 'utils/auth_helper'
require_relative 'models/user'
require_relative 'models/product'
require_relative 'models/category'
require_relative 'models/order'
require_relative 'models/review'
require_relative 'models/banner'
require_relative 'utils/cloudinary_helper'
require_relative 'utils/xendit_helper'
require_relative 'helpers/view_helper'

require_relative 'controllers/auth_controller'
require_relative 'controllers/admin_controller'
require_relative 'controllers/shop_controller'

class Router
  include AuthController
  include AdminController
  include ShopController

  def initialize(env)
    @req = Rack::Request.new(env)
  end

  def route
    case @req.path
    when '/'
      render_view('home')
    when '/shop'
      render_view('shop')
    when '/product'
      render_view('product')
    when '/categories'
      render_view('categories')
    when '/about'
      render_view('about')
    when '/contact'
      render_view('contact')
    when '/terms'
      render_view('terms')
    when '/cart'
      render_view('cart')
    when '/cart/add'
      handle_cart_add if @req.post?
    when '/cart/remove'
      handle_cart_remove
    when '/cart/update'
      handle_cart_update if @req.post?
    when '/checkout'
      require_auth do
        if @req.post?
          handle_checkout
        else
          render_view('checkout')
        end
      end
    when '/order-success'
      id = @req.params['id']
      order = Order.find(id) if id
      render_view('order_success', { order: order })
    when '/sitemap.xml'
      render_sitemap
    when '/robots.txt'
      render_robots
    when '/search'
      render_view('search')
    when '/account'
      require_auth { render_view('account') }
    when '/product/review'
      require_auth { handle_product_review }
    when '/wishlist/add'
      require_auth { handle_wishlist_add }
    when '/account/update'
      require_auth { handle_account_update if @req.post? }
    when '/wishlist/remove'
      require_auth { handle_wishlist_remove }
    when '/login'
      return redirect_to('/account') if AuthHelper.authenticated?(@req)
      if @req.post?
        handle_login
      else
        render_view('login', layout: false)
      end
    when '/logout'
      handle_logout
    when '/admin'
      require_admin { render_view('admin/dashboard') }
    when '/admin/products'
      require_admin { render_view('admin/products') }
    when '/admin/products/new'
      require_admin do
        if @req.post?
          handle_product_create
        else
          render_view('admin/products_new')
        end
      end
    when '/admin/products/edit'
      require_admin do
        id = @req.params['id']
        product = Product.find(id)
        if product
          render_view('admin/products_edit', { product: product })
        else
          redirect_to('/admin/products')
        end
      end
    when '/admin/products/update'
      require_admin { handle_product_update if @req.post? }
    when '/admin/products/delete'
      require_admin { handle_product_delete }
    when '/admin/categories'
      require_admin do
        if @req.post?
          Category.create(name: @req.params['name'])
          redirect_to('/admin/categories')
        else
          render_view('admin/categories')
        end
      end
    when '/admin/categories/delete'
      require_admin do
        Category.delete(@req.params['id'])
        redirect_to('/admin/categories')
      end
    when '/admin/banners'
      require_admin { render_view('admin/banners') }
    when '/admin/banners/new'
      require_admin { render_view('admin/banners_new') }
    when '/admin/banners/add'
      require_admin { handle_banner_add if @req.post? }
    when '/admin/banners/delete'
      require_admin { handle_banner_delete }
    when '/admin/orders'
      require_admin { render_view('admin/orders') }
    when '/admin/orders/view'
      require_admin do
        id = @req.params['id']
        order = Order.find(id)
        if order
          render_view('admin/order_view', { order: order })
        else
          redirect_to('/admin/orders')
        end
      end
    when '/admin/orders/update'
      require_admin { handle_order_update }
    when '/admin/orders/export'
      require_admin { handle_orders_export }
    when '/register'
      return redirect_to('/account') if AuthHelper.authenticated?(@req)
      if @req.post?
        handle_register
      else
        render_view('register', layout: false)
      end
    when '/webhooks/xendit'
      handle_xendit_webhook if @req.post?
    else
      [404, { 'content-type' => 'text/html' }, ['Halaman Tidak Ditemukan']]
    end
  end

  private

  def require_auth
    if AuthHelper.authenticated?(@req)
      yield
    else
      redirect_to('/login')
    end
  end

  def require_admin
    if AuthHelper.admin?(@req)
      yield
    else
      redirect_to('/login')
    end
  end

  def redirect_to(path)
    [302, { 'location' => path }, []]
  end

  def render_sitemap
    products = Product.all
    base_url = "https://#{@req.host_with_port}"
    
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    xml += "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
    
    # Home & Core Pages
    ["", "/shop", "/categories", "/about", "/contact", "/terms"].each do |path|
      xml += "  <url><loc>#{base_url}#{path}</loc><priority>#{path == '' ? '1.0' : '0.8'}</priority></url>\n"
    end
    
    # Products
    products.each do |p|
      xml += "  <url><loc>#{base_url}/product?id=#{p.id}</loc><priority>0.6</priority></url>\n"
    end
    
    xml += "</urlset>"
    
    [200, { 'content-type' => 'application/xml' }, [xml]]
  end

  def render_robots
    base_url = "https://#{@req.host_with_port}"
    txt = "User-agent: *\n"
    txt += "Allow: /\n"
    txt += "Disallow: /admin\n"
    txt += "Disallow: /account\n"
    txt += "Disallow: /cart\n"
    txt += "Disallow: /checkout\n\n"
    txt += "Sitemap: #{base_url}/sitemap.xml\n"
    
    [200, { 'content-type' => 'text/plain' }, [txt]]
  end

  def render_view(view, locals = {}, layout: true, **extra_locals)
    view_path = File.expand_path("../views/#{view}.html.erb", __FILE__)
    unless File.exist?(view_path)
      return [404, { 'content-type' => 'text/html' }, ["Tampilan tidak ditemukan: #{view}"]]
    end

    locals = locals.merge(extra_locals)
    locals.each { |k, v| instance_variable_set("@#{k}", v) }

    template = File.read(view_path)
    main_content = ERB.new(template).result(binding)

    if layout
      layout_path = File.expand_path("../views/layout.html.erb", __FILE__)
      layout_template = File.read(layout_path)
      final_content = ERB.new(layout_template).result(binding)
    else
      final_content = main_content
    end

    [200, { 'content-type' => 'text/html' }, [final_content]]
  end
end
