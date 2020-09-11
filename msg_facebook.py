import os
import fbchat
import pyotp

totp = pyotp.TOTP(os.environ["FB_TOTP"])
class CustomClient(fbchat.Client):
    def on2FACode(self):
        return totp.now()
client = CustomClient(os.environ["FB_EMAIL"], os.environ["FB_PASS"])

client.send(fbchat.Message(text=os.environ["FB_MESSAGE"]), thread_id=os.environ["FB_GROUP_ID"], thread_type=fbchat.ThreadType.GROUP)
client.sendLocalFiles("current.png", thread_id=os.environ["FB_GROUP_ID"], thread_type=fbchat.ThreadType.GROUP)
if os.environ["diff_exitcode"] == "1":
    client.sendLocalFiles("comparison.png", thread_id=os.environ["FB_GROUP_ID"], thread_type=fbchat.ThreadType.GROUP)