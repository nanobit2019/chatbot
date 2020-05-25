require_relative './../../spec_helper.rb'

describe FaqModule::CreateService do
  before do
    @question = FFaker::Lorem.sentence
    @answer = FFaker::Lorem.sentence
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do
    context 'without hashtag params' do
      it 'will receive a error' do
        @createService = FaqModule::CreateService.new({"question" => @question, "answer" => @answer})
        response = @createService.call()
        expect(response).to match("Hashtag Obrigatório")
      end  
    end

    context 'with valid params' do
      before do
        @createService = FaqModule::CreateService.new({"question" => @question, "answer" => @answer, "hashtags" => @hashtags})
        @response = @createService.call()
      end

      it 'Receive success message' do
        expect(@response).to match("Criado com sucesso")
      end

      it 'Question and answer is present in database' do
        expect(Faq.last.question).to match(@question)
        expect(Faq.last_answer).to match(@answer)
      end

      it 'Hashtags are created' do
        expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
        expect(@hashtags.split(/[\s,]+]/).last).to match(Hashtag.last.name)
      end
    end
  end
end