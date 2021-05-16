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

  def help_message_blocks
    {
      "text": 'Help from Birthday Bot!',
      "blocks": [
        {
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": "Hey <@#{@user.slack_id}> :smiley:! I'm glad you asked for help :blush:.\n• Use `/birthday` to add your birthday.\n• Use `/birthday list` to get list of added birthdays."
          }
        },
        {
          "type": 'actions',
          "elements": [
            {
              "type": 'button',
              "action_id": 'add-birthday',
              "text": {
                "type": 'plain_text',
                "text": 'Add my birthday :birthday:',
                "emoji": true
              }
            },
            {
              "type": 'button',
              "action_id": 'next-birthday',
              "text": {
                "type": 'plain_text',
                "text": 'Whose birthday is next? :star-struck:',
                "emoji": true
              }
            },
            {
              "type": 'button',
              "action_id": 'complete-list',
              "text": {
                "type": 'plain_text',
                "text": 'Show me Complete List :scroll:',
                "emoji": true
              }
            }
          ]
        }
      ]
    }
  end
end
