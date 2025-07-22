import sys
import os
sys.path.append(os.path.dirname(os.path.realpath(__file__))+"/../python_launcher/src")

from action_sender import ActionSender

BASE = 100
def format_p(val):
    return f"g06_injection_PRefPu,input_value,double,{-val/BASE}"

def format_q(val):
    return f"g06_injection_QRefPu,input_value,double,{-val/BASE}"


if __name__ == '__main__':
    sender = ActionSender()

    # SCENARIO: from t0 position (P0 = 360 MW, Q0 = 138 MVAr)
    #    t = 0  ---> t = 10 : P, Q constant
    #    t = 11 ---> t = 70 : P ramp up to 400MW, Q cst
    #    t = 71 ---> t = 130: P ramp down to 350 MW, P/Q cst
    #    t =131 ---> t = 180: P, Q constant
    p = 360
    q = 138.6
    for _ in range(9):
        sender.send("")

    dp = 40/60
    for i in range(60):
        p += dp
        sender.send(format_p(p))
        sender.send("")

    dp = -(50/60)
    dq = dp * q / p
    for i in range(60):
        p += dp
        q += dq
        sender.send(format_p(p))
        sender.send(format_q(q))
        sender.send("")

    for _ in range(50):
        sender.send("")

    sender.send("stop")
