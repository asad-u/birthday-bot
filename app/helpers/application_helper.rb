module ApplicationHelper
  def update_birthday_modal
    {
      "title": {
        "type": 'plain_text',
        "text": 'Birthday Bot'
      },
      "submit": {
        "type": 'plain_text',
        "text": 'Submit'
      },
      "blocks": [
        {
          "type": 'input',
          "element": {
            "type": 'datepicker',
            "initial_date": @user.birthday&.date.present? ? @user.birthday&.date : '1990-04-28',
            "placeholder": {
              "type": 'plain_text',
              "text": 'Select a date',
              "emoji": true
            },
            "action_id": 'datepicker-action'
          },
          "label": {
            "type": 'plain_text',
            "text": 'Nice! Choose your birthday',
            "emoji": true
          }
        }
      ],
      "type": 'modal'
    }
  end
end
