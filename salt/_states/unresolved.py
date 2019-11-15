# -*- coding: utf-8 -*-
"""
"""


def addresses(name):
    """
    """
    ret = {'name': name, 'changes': {}, 'result': None, 'comment': ''}

    if __opts__['test'] == True:
        return ret

    result = __salt__['unresolved.addresses']()

    if result:
        ret['result'] = False
        ret['comment'] = result
    else:
        ret['result'] = True
    return ret
