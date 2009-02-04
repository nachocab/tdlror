require 'test_helper'

class PatternsTest < ActiveSupport::TestCase
  context "The Template Method: Vary the algorithm" do
    # p.88 Separate things that change from those that stay the same
    setup do
      class Capoeira
        def initialize
          @grupo = "é bamba"
          @historia = ""
        end

        def jogo # Template method. It stays the same for all subclasses
          forma_roda
          canta_ladainha
          canta_sao_bento_pequeno
          canta_sao_bento_grande
        end
        
        def forma_roda
          @historia << "#{grupo} #{@grupo} "
        end

        def grupo
          raise 'Abstract method: grupo'
        end

        def canta_ladainha # Abstract method
          raise 'Abstract method: canta_ladainha'
        end

        def canta_sao_bento_pequeno
          raise 'Abstract method: canta_sao_bento_pequeno'
        end

        def canta_sao_bento_grande # Hook method
          @historia << 'Vento balançou a palha do coqueiro'
        end
      end
      
      class Regional < Capoeira # Concrete class
        def grupo # concrete method
          "Capoeira Gerais"
        end
        def canta_ladainha
          @historia << 'Mestre Bimba é '
        end

        def canta_sao_bento_pequeno
          @historia << 'Da, da, da no nego '
        end

        def canta_sao_bento_grande
          @historia << 'Brincadeira creada por Bimba, foi no grupo Ginga que eu aprendi'
        end

      end
      
      class Angola < Capoeira # Concrete class
        def grupo
          "FICA"
        end
        def canta_ladainha
          @historia << 'Luanda ê '
        end
        def canta_sao_bento_pequeno
          @historia << 'Jogo de dentro, jogo legal '
        end
      end
    end

    should "build an abstract base class with a template method" do
      assert c = Capoeira.new
      assert_raise RuntimeError do
        c.jogo
      end
    end

    should "build concrete subclasses that supply the logic" do
      reg = Regional.new
      jogo_regional = "Capoeira Gerais é bamba Mestre Bimba é Da, da, da no nego Brincadeira creada por Bimba, foi no grupo Ginga que eu aprendi"
      assert_equal jogo_regional, reg.jogo

      ang = Angola.new
      jogo_angola = "FICA é bamba Luanda é Jogo de dentro, jogo legal Vento balançou a palha do coqueiro"
      assert_equal jogo_angola.length, ang.jogo.length
    end
  end

  context "The Strategy: Replace the algorithm " do
    # p.106 Implement each version of the algorithm as a separate object. You can then
    # choose which version you want by supplying the context with different strategy
    # objects.
    #
    # Communication between context and strategies:
    #  1) the context sends all data as arguments when calling strategy methods
    #  2) pass a reference to the whole context object to the strategy.
    #
    #
    #   Advantages:
    #   - we relieve the Context class of any responsability of knowing anything
    #     about its Strategy classes. (For example, Regional doesn't have to play SBP).
    #   - It's easy to switch strategies at runtime.

    setup do
      class Estilo
        def jogo( grupo )
          raise 'Abstract method: jogo'
        end
      end

      class EstiloRegional < Estilo # Strategy
        def jogo( grupo )
          "#{grupo} é bamba. Forma roda, canta ladainha, canta SB grande"
        end
      end

      class EstiloAngola < Estilo # Strategy
        def jogo( grupo )
          "#{grupo} é bamba. Forma roda, canta ladainha, canta SB pequeno"
        end
      end

      class Capoeira # Context
        attr_reader :grupo
        attr_accessor :estilo

        def initialize(grupo, estilo)
          @grupo = grupo
          @estilo = estilo
        end
        # The context uses the interface provided by the strategies. Problem: all
        # variables must be passed as arguments.
        def jogo
          @estilo.jogo(@grupo)
        end
      end
    end

    should "define a family of objects (strategies) that do the
            same thing and have the same interface" do
      assert EstiloAngola.new.jogo('FICA')
      assert EstiloRegional.new.jogo('Capoeira Gerais')
    end

    should "define the object that will be using the strategies (the context)" do
      assert Capoeira.new('FICA', EstiloAngola.new).jogo
      assert Capoeira.new('Capoeira Gerais', EstiloRegional.new).jogo
    end

    should "be easy to switch strategies at runtime" do
      c = Capoeira.new('FICA', EstiloAngola.new)
      assert c.jogo
      c = Capoeira.new('Capoeira Gerais', EstiloRegional.new)
      assert c.jogo
    end

    should "variant: we can pass the data from the context to the strategy using self" do
      # This simplifies the flow of data because we only have to pass one variable as
      # argument. Problem: increases the coupling between context and strategies.
      class Capoeira
        #        def initialize(grupo, estilo)
        #          @grupo = grupo
        #          @estilo = estilo
        #        end
        def jogo
          @estilo.jogo(self) # advantage, we only have to pass one argument.
        end
      end

      class Estilo
        def jogo(context)
          raise 'Abstract method: jogo'
        end
      end

      class EstiloRegional < Estilo # Now, the strategy depends on the context having a 'grupo' attr.
        def jogo(context)
          "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB grande"
        end
      end

      class EstiloAngola < Estilo
        def jogo(context)
          "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB pequeno"
        end
      end

      assert reg = Capoeira.new('FICA', EstiloAngola.new)
      assert reg.jogo
      assert ang = Capoeira.new('Capoeira Gerais', EstiloRegional.new)
      assert ang.jogo
    end

    should "variant: remove abstract class" do
      # The abstract class doesn't really do anything.
      class Capoeira
        #        def initialize(grupo, estilo)
        #          @grupo = grupo
        #          @estilo = estilo
        #        end
        def jogo
          @estilo.jogo(self) # advantage, we only have to pass one argument.
        end
      end


      class EstiloRegional # Now, the strategy depends on the context having a 'grupo' attr.
        def jogo(context)
          "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB grande"
        end
      end

      class EstiloAngola 
        def jogo(context)
          "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB pequeno"
        end
      end

      assert reg = Capoeira.new('FICA', EstiloAngola.new)
      assert reg.jogo
      assert ang = Capoeira.new('Capoeira Gerais', EstiloRegional.new)
      assert ang.jogo
    end

    should "variant: using Procs" do
      # Advantages:
      #    we don't have to create new classes to implement strategies.
      #    ***we can create new strategies on-the-fly.
      # Better used when the strategy interface is simple.
      class Capoeira
        attr_reader :grupo
        attr_accessor :estilo

        def initialize(grupo, &estilo)
          @grupo = grupo
          @estilo = estilo
        end

        def jogo
          @estilo.call(self)
        end
      end


      ESTILO_REGIONAL = lambda do |context| # Now, the strategy depends on the context having a 'grupo' attr.
        "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB grande"
      end

      ESTILO_ANGOLA = lambda do |context|
        "#{context.grupo} é bamba. Forma roda, canta ladainha, canta SB pequeno"
      end

      assert reg = Capoeira.new('FICA', &ESTILO_ANGOLA)
      assert reg.jogo
      assert ang = Capoeira.new('Capoeira Gerais', &ESTILO_REGIONAL)
      assert ang.jogo
    end
  end

  context "The Observer: Keeping up with the times" do
    # p. 124
    # The source of the news is called the subject class.
    # The observers are the objects interested in getting the news
    require 'observer'
    class TaxMan
      attr_reader :response
      def update(changed_employee)
        @response = "#{changed_employee.salary} more for me!"
      end
    end

    class Employee
      include Observable

      attr_reader :name, :salary, :address

      def initialize( name, title, salary )
        @name, @title, @salary = name, title, salary
      end

      def salary=(new_salary) 
        @salary = new_salary
        changed 
        notify_observers(self) # defined in ruby class Observable.
      end
    end
    should "create observer and subject" do
      tax_man = TaxMan.new
      pepe = Employee.new('pepe','jefe','rue del percebe')
      pepe.add_observer(tax_man) # defined in ruby class Observable.
      pepe.salary = 20_000
      assert_equal "20000 more for me!", tax_man.response
    end
  end

  context "The Composite: Assembling the whole from the parts" do
    # p.140
  end

  context "The Iterator: Reaching into a collection" do
    # p.156
  end

  context "Commands: Getting things done." do
    # p.172
  end

  context "The Adapter: Filling in the gaps" do
    # p.192
  end

  context "The Proxy: Getting in front of your object." do
    # p.204
  end

  context "The Decorator: Improving your objects" do
    # p.222
  end

  context "The Singleton: Making sure there is only one" do
    # p.236
  end

  context "The Factory: Picking the right class" do
    # p.256
  end

  context "The Builder: Easier object construction" do
    # p.278
  end

  context "The Interpreter: Assembling your system" do
    # p.292
  end

  context "DSLs: Opening up your system" do
    # p.312
  end

  context "Meta-programming: Creating custom objects" do
    # p.326
  end

  context "Convention over configuration" do
    # p.342
  end

end