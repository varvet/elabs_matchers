require "spec_helper"
require "fixtures/post"

describe ElabsMatchers::Matchers::BeValidWith do
  let(:post) { ElabsMatchers::Orm::Post.create }
  subject { post }

  context "with one example value" do
    context "with one attribute" do
      it { should be_valid_with("Elabs").as(:title) }
      it { should_not be_valid_with("", []).as(:title) }

      it { expect { should be_valid_with("").as(:title) }.to fail_assertion }
      it { expect { should_not be_valid_with("Elabs").as(:title) }.to fail_assertion }
      it { expect { should_not be_valid_with("").as(:signature) }.to fail_assertion }
    end

    context "with several attributes" do
      it { should be_valid_with("Elabs").as(:title, :body) }
      it { should_not be_valid_with("").as(:title, :body) }

      it { expect { should be_valid_with("").as(:title, :body) }.to fail_assertion }
      it { expect { should_not be_valid_with("Elabs").as(:title, :body) }.to fail_assertion }

      it { expect { should be_valid_with("").as(:title, :signature) }.to fail_assertion }
      it { expect { should_not be_valid_with("").as(:title, :signature) }.to fail_assertion }
    end
  end

  context "with several example values" do
    context "with one attribute" do
      it { should be_valid_with("Elabs", "Sweden").as(:title) }
      it { should_not be_valid_with("", nil).as(:title) }

      it { expect { should be_valid_with("Elabs", "").as(:title) }.to fail_assertion }
      it { expect { should_not be_valid_with("", "Elabs").as(:title) }.to fail_assertion }
      it { should be_valid_with("", "Elabs").as(:signature) }
    end

    context "with several attributes" do
      it { should be_valid_with("Elabs", "Sweden").as(:title, :body) }
      it { should_not be_valid_with("", nil).as(:title, :body) }

      it { expect { should be_valid_with("Elabs", "").as(:title, :body) }.to fail_assertion }
      it { expect { should_not be_valid_with("", "Elabs").as(:title, :body) }.to fail_assertion }

      it { expect { should be_valid_with("", "Elabs").as(:title, :signature) }.to fail_assertion }
      it { expect { should_not be_valid_with("", "Elabs").as(:title, :signature) }.to fail_assertion }
    end
  end

  context "non-string values" do
    it { should be_valid_with(Date.today).as(:published_on) }
    it { should be_valid_with(Time.now).as(:published_on) }
    it { should be_valid_with(DateTime.now).as(:published_on) }

    it { should be_valid_with(nil).as(:signature) }
    it { should_not be_valid_with(nil).as(:title) }
    it { should be_valid_with(9).as(:title) }
    it { should be_valid_with(:bar).as(:title) }

    it { should be_valid_with(["Peter", "Bob"], ["Marry", "Anna"]).as(:authors) }
    it { should be_valid_with(:first_name => "Peter", :last_name => "Smith").as(:co_author) }
  end

  context "some aditional examples just for illustrating more use-cases" do
    context "inclusion" do
      it { should be_valid_with("sci-fi", "thriller").as(:category) }
      it { should_not be_valid_with("pocket", nil).as(:category) }
      it { expect { should be_valid_with("pocket", "").as(:category) }.to fail_assertion }
      it { expect { should_not be_valid_with("sci-fi", "thriller").as(:category) }.to fail_assertion }
    end

    context "numericality" do
      it { should be_valid_with(9, "9", "9e3", 0.1).as(:price) }
      it { should_not be_valid_with("cheap", nil).as(:price) }
      it { expect { should be_valid_with("cheap", nil).as(:price) }.to fail_assertion }
      it { expect { should_not be_valid_with(9, "9", "9e3", 0.1).as(:price) }.to fail_assertion }
    end
  end
end
