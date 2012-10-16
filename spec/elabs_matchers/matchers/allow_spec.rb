require "spec_helper"
require "fixtures/post"

describe ElabsMatchers::Matchers::Allow do
  let(:post) { ElabsMatchers::Orm::Post.create }
  subject { post }

  context "with one example value" do
    context "with one attribute" do
      it { should allow("Elabs").as(:title) }
      it { should_not allow("", []).as(:title) }

      it { expect { should allow("").as(:title) }.to fail_assertion }
      it { expect { should_not allow("Elabs").as(:title) }.to fail_assertion }
      it { expect { should_not allow("").as(:signature) }.to fail_assertion }
    end

    context "with several attributes" do
      it { should allow("Elabs").as(:title, :body) }
      it { should_not allow("").as(:title, :body) }

      it { expect { should allow("").as(:title, :body) }.to fail_assertion }
      it { expect { should_not allow("Elabs").as(:title, :body) }.to fail_assertion }

      it { expect { should allow("").as(:title, :signature) }.to fail_assertion }
      it { expect { should_not allow("").as(:title, :signature) }.to fail_assertion }
    end
  end

  context "with several example values" do
    context "with one attribute" do
      it { should allow("Elabs", "Sweden").as(:title) }
      it { should_not allow("", nil).as(:title) }

      it { expect { should allow("Elabs", "").as(:title) }.to fail_assertion }
      it { expect { should_not allow("", "Elabs").as(:title) }.to fail_assertion }
      it { should allow("", "Elabs").as(:signature) }
    end

    context "with several attributes" do
      it { should allow("Elabs", "Sweden").as(:title, :body) }
      it { should_not allow("", nil).as(:title, :body) }

      it { expect { should allow("Elabs", "").as(:title, :body) }.to fail_assertion }
      it { expect { should_not allow("", "Elabs").as(:title, :body) }.to fail_assertion }

      it { expect { should allow("", "Elabs").as(:title, :signature) }.to fail_assertion }
      it { expect { should_not allow("", "Elabs").as(:title, :signature) }.to fail_assertion }
    end
  end

  context "non-string values" do
    it { should allow(Date.today).as(:published_on) }
    it { should allow(Time.now).as(:published_on) }
    it { should allow(DateTime.now).as(:published_on) }

    it { should allow(nil).as(:signature) }
    it { should_not allow(nil).as(:title) }
    it { should allow(9).as(:title) }
    it { should allow(:bar).as(:title) }

    it { should allow(["Peter", "Bob"], ["Marry", "Anna"]).as(:authors) }
    it { should allow(:first_name => "Peter", :last_name => "Smith").as(:co_author) }
  end

  context "some aditional examples just for illustrating more use-cases" do
    context "inclusion" do
      it { should allow("sci-fi", "thriller").as(:category) }
      it { should_not allow("pocket", nil).as(:category) }
      it { expect { should allow("pocket", "").as(:category) }.to fail_assertion }
      it { expect { should_not allow("sci-fi", "thriller").as(:category) }.to fail_assertion }
    end

    context "numericality" do
      it { should allow(9, "9", "9e3", 0.1).as(:price) }
      it { should_not allow("cheap", nil).as(:price) }
      it { expect { should allow("cheap", nil).as(:price) }.to fail_assertion }
      it { expect { should_not allow(9, "9", "9e3", 0.1).as(:price) }.to fail_assertion }
    end
  end
end
