class AccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = Account.new(
      original_balance: nil,
      accountable: Accountable.from_type(params[:type])&.new
    )
  end

  def show
    @account = Current.family.accounts.find(params[:id])
  end

  def create
    @account = Current.family.accounts.build(account_params.except(:accountable_type))
    @account.accountable = Accountable.from_type(account_params[:accountable_type])&.new

    if @account.save
      redirect_to accounts_path, notice: t(".success")
    else
      render "new", status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :accountable_type, :original_balance, :original_currency, :subtype)
  end
end
