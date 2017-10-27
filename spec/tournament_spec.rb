require 'tournament'

describe Tournament do
  let(:bot_1) { double :bot, go: [:r], name: "A" }
  let(:bot_2) {double :bot, go: [:s], name: "B" }

  subject(:tournament){ described_class.new(bot_1, bot_2) }
  context 'with two valid bots' do
    it "is ready" do
      expect(tournament.ready?).to be true
    end
  end

  context '#fight' do
    context "with one fight" do
      it "knows the report" do
        subject.fight(1)
        expect(subject.report).to eq "A,B,1,0,A\n"
      end
    end

    context "with multiple fights" do
      it "knows the report" do
        subject.fight(10)
        expect(subject.report).to eq "A,B,10,0,A\n"
      end

      it "tells each bot the previous moves" do
        expect(bot_1).to receive(:go).once.with([])
        expect(bot_2).to receive(:go).once.with([])
        subject.fight(2)
      end
    end
  end
end
