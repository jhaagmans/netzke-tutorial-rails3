module Netzke
  class BasicAppDemo < BasicApp
    # Customizing the application layout. We can put any stuff we want in here,
    # the only agreement is to specify 2 fit panels with ids "main-panel" &
    # "main-toolbar" that will be used by Netzke::BasicApp.
    # In this case we simple add another banner-like panel in the north, and in the center - the layout from BasicApp
    def self.js_panels
      [{
        :region => 'north',
        :height => 40,
        :html => %Q{
          <div style="margin:10px; color:#333; text-align:center; font-family: Helvetica;">
            <span style="color:#B32D15">Netzke</span> basic application demo
          </div>
        },
        :bodyStyle => {"background" => "#FFF url(\"/images/header-deco.gif\") top left repeat-x"}
      },{
        :region => 'center',
        :layout => 'border',
        :items => super
      }]
    end

    #
    # Specify available actions for the application
    #
    def actions
      fn = :load_widget_by_action
      super.merge({ 
        :clerks                => {:text => "Clerks",                       :handler => fn},
        :bosses                => {:text => "Bosses",                       :handler => fn},
        :bosses_and_clerks     => {:text => "Bosses and clerks",            :handler => fn},
        :bosses_and_clerks_ext => {:text => "Bosses and clerks (extended)", :handler => fn},
        :users                 => {:text => "Users",                        :handler => fn},
        :roles                 => {:text => "Roles",                        :handler => fn},
        :custom_actions_grid   => {:text => "Custom actions grid",          :handler => fn},
      })
    end
    
    #
    # Specify the menu
    #
    def menu
      common_menu = [{
        :text => "Tutorials",
        :menu => %w{ clerks bosses bosses_and_clerks bosses_and_clerks_ext custom_actions_grid}
      }]
      
      # only add the Admin menu when the user has role "administrator"
      current_user = User.find_by_id(session[:netzke_user_id])
      if current_user.try(:role).try(:name) == 'administrator'
        common_menu.unshift(:text => "Admin", :menu => %w{ users roles toggle_config_mode masquerade_selector})
      end
      
      common_menu + super
    end
    
    # Prevent access to UserManager and roles for anonimous users
    #
    def load_aggregatee_with_cache(params)
      widget = params[:id].underscore
      current_user = User.find_by_id(session[:netzke_user_id])
      if current_user.nil? && (widget == "users" || widget == 'roles')
        flash :error => "You don't have access to this widget"
        {:feedback => @flash}
      else
        super
      end
    end
    
    #
    # Here are the widgets that our application will be able to load dynamically (see the demo for Netzke::GridPanel)
    #
    def initial_late_aggregatees
      {
        :clerks => {
          :class_name => "BorderLayoutPanel",
          :ext_config => {
            :header => false
          },
          :regions => {
            :center => {
              :class_name => "GridPanel", 
              :model => "Clerk", 
              :ext_config => {
                :title => 'Clerks',
                :rows_per_page => 20
              }
            },
            :south => {
              :class_name => "Panel",
              :region_config => {
                :height => 190,
                :split => true,
                :collapsed => true,
                :collapsible => true
              },
              :ext_config => {
                :title => "Explanation",
                :body_style => "padding: 5px",
                :html => %Q{What you see is a BorderLayoutPanel-based compound widget, containing a GridPanel interfacing the Clerks model, and a Panel with a little explanation (the one you are reading). <br>What is here to play with: <br>1) Do some on-the-fly configuration of the grid - move around or resize its columns, change something in the columns configuration panel (click the tool-button in the up-right corner while in configuration mode), and then log out and in again - you'll see that your changes got stored; <br>2) Change the size of this (south) region - it'll get stored for you as well, by to the BorderLayoutPanel widget. <br>The same explanation naturally applies to the <a href="#bosses">bosses</a> view.
}
              }
            }
          }
        },

        :bosses => {
          :class_name => "BorderLayoutPanel",
          :ext_config => {
            :header => false
          },
          :regions => {
            :center => {
              :class_name => "GridPanel", 
              :model => "Boss", 
              :ext_config => {
                :title => "Bosses",
                :rows_per_page => 20
              }
            },
            :south => {
              :class_name => "Panel",
              :region_config => {
                :height => 70,
                :collapsed => true,
                :collapsible => true,
                :split => true
              },
              :ext_config => {
                :title => "Explanation",
                :body_style => "padding: 5px",
                :html => %Q{See the explanations for the <a href="#clerks">clerks</a> view.}
              }
            }
          }
        },

        :bosses_and_clerks_ext => {
          :class_name    => "BossesAndClerks"
        },

        :bosses_and_clerks => {
          :class_name    => "OneToManyGridSetPoc",
          :container_class_name => "Boss",
          :element_class_name   => "Clerk"
        },

        :masquerade_selector => {
          :class_name => "MasqueradeSelector"
        },
        
        :roles => {
          :class_name => "GridPanel",
          :model => "Role"
        },

        :users => {
          :class_name => "GridPanel",
          :model => "User",
          :columns => [:id, :login, :role__name, :login_count, :last_login_at, :last_request_at, :active_recently]
        },
        
        :custom_actions_grid => {
          :class_name => "CustomActionGrid",
          :model => "Boss",
          :ext_config => {:title => "Bosses"}
        }
      }
    end
    
    # We need to do this, otherwise the panels are taken from the parent class
    def self.js_extend_properties
      {
        :panels => self.js_panels
      }
    end
    
    # WORKAROUND badly implemented inheritance
    # Because of the inheritance, we need to reset these methods
    # def self.include_js
    #   []
    # end
    # end WORKAROUND
    
  end
end