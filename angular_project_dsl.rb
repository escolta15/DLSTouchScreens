class AngularProjectDSL

  def initialize(touch_screen)
    @project_name = touch_screen.name
    @packages = []
    @touch_screen = touch_screen
    @components = []
    @models = []
  end

  def package(name, version)
    @packages << { name: name, version: version }
  end

  def component(name)
    @components << { name: name }
  end

  # Generador
  def generate
    # Verifica si el directorio del proyecto ya existe
    if !Dir.exist?(@project_name)
        # Crea la estructura del proyecto Angular si no existe
        system("ng new #{@project_name} --routing --style=scss --directory=./#{@project_name}")
    else
        puts("The project #{@project_name} exists. It will not be created again.")
    end

    # Ingresa en el directorio del proyecto
    Dir.chdir(@project_name) do
      install_packages()
      add_icons()

      # Personaliza el contenido del componente app utilizando plantillas ERB
      files = Dir.glob(File.join('../templates/app/', '*'))
      read_templates(files, 'src/app/', binding)

      # Genera los componentes
      @components.each do |component|
        component_name = component[:name]

        # Verifica si el directorio del componente ya existe
        component_dir = "src/app/#{component_name}"
        if !Dir.exist?(component_dir)
          # Genera el componente si no existe
          system("ng generate component #{component[:name]}")
        else
          puts("The component #{component_name} exists. It will not be generated again.")
        end
        
        # Modifica el archivo del componente
        files = Dir.glob(File.join("../templates/#{component_name}/", '*'))
        read_templates(files, "src/app/#{component_name}/", binding)
      end

      # Genera los modelos
      create_folder('models')
      @models = Dir.glob(File.join('../templates/models/', '*'))
      read_templates(@models, 'src/models/', binding)
    end
  end

  private

  # Metodo para instalar los paquetes npm
  def install_packages()
    @packages.each do |package|
      # Ejecuta el comando npm install para instalar el paquete
      system("npm install #{package[:name]}@#{package[:version]}")
    end
  end

  # Metodo para agregar los iconos al archivo de estilos
  def add_icons
    read_templates(['../templates/styles.scss.erb'], 'src/', binding)
  end

  # Metodo para crear una carpeta
  def create_folder(name)
    folder = "src/#{name}"
    if !Dir.exist?(folder)
      # Si no existe, crea la carpeta
      Dir.mkdir(folder)
    end
  end

  # Metodo para leer las plantillas
  def read_templates(files, path, data_binding)
    for file in files
      filename = find_file(file)
      file_path = "#{path}#{filename}"

      # Leer la plantilla ERB desde el archivo
      erb_template = File.read("#{file}")

      # Crear una instancia de la clase ERV
      erb = ERB.new(erb_template)

      # Realizar el enlace de datos utilizando el contexto de binding proporcionado
      result = erb.result(data_binding)

      # Escribe el contenido modificado de vuelta al archivo
      File.open(file_path, "w") { |file| file.write(result) }
    end
  end

  # Metodo para coger el nombre del archivo
  def find_file(file)
    parts = file.split('/')
    filename = parts.find { |part| part.end_with?(".erb") }
    filename = filename.sub(/\.erb$/, '')
    return filename
  end

end
