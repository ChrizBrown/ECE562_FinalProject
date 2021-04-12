/**
 * Copyright (c) 2018 Inria
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met: redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer;
 * redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution;
 * neither the name of the copyright holders nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "mem/cache/replacement_policies/slru_rp.hh"

#include <cassert>
#include <memory>

#include "params/SLRURP.hh"
#include "sim/core.hh"

#define PROT_SIZE 10

SLRURP::SLRURP(const Params *p)
    : BaseReplacementPolicy(p)
{
}

void
SLRURP::invalidate(const std::shared_ptr<ReplacementData>& replacement_data)
const
{
    // Reset last touch timestamp
    std::static_pointer_cast<SLRUReplData>(
        replacement_data)->lastTouchTick = Tick(0);
    std::static_pointer_cast<SLRUReplData>(
        replacement_data)->protect = 0;
}

void
SLRURP::touch(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    // Update last touch timestamp
    std::static_pointer_cast<SLRUReplData>(
        replacement_data)->lastTouchTick = curTick();
    if(std::static_pointer_cast<SLRUReplData>(
        replacement_data)->protect == 0) {
            std::static_pointer_cast<SLRUReplData>(replacement_data)->protect = 1; //FIXME is this called when a new blocks is placed in cache?
    }
}

void
SLRURP::reset(const std::shared_ptr<ReplacementData>& replacement_data) const
{
    // Set last touch timestamp
    std::static_pointer_cast<SLRUReplData>(
        replacement_data)->lastTouchTick = curTick();
    std::static_pointer_cast<SLRUReplData>(
        replacement_data)->protect = 0;//FIXME What should this be?
}

ReplaceableEntry*
SLRURP::getVictim(const ReplacementCandidates& candidates) const
{
    // There must be at least one replacement candidate
    assert(candidates.size() > 0);

    //Demote all but PROT_SIZE most recent protected
    ReplaceableEntry* demote = candidates[0];
    int number_protected;
    do{
        number_protected=0;
        //Find the LRU in the protected seg and count protected blocks
        for (const auto& candidate : candidates) {
            if (std::static_pointer_cast<SLRUReplData>(candidate->replacementData)->protect ==1){
                number_protected++;
                if (std::static_pointer_cast<SLRUReplData>(candidate->replacementData)->lastTouchTick < std::static_pointer_cast<SLRUReplData>(demote->replacementData)->lastTouchTick) {
                    demote = candidate;
                }
            }
        }
        //If protected segment is too large, move protected seg LRU block to probationary seg MRU block
        if(std::static_pointer_cast<SLRUReplData>(demote->replacementData)->protect == 1 && number_protected > PROT_SIZE){
            std::static_pointer_cast<SLRUReplData>(demote->replacementData)->protect = 0; //Move block to probationary segment
            std::static_pointer_cast<SLRUReplData>(demote->replacementData)->lastTouchTick = curTick();//Make MRU
            number_protected--; //Update the number protected (for while statement)
        }
    } while (number_protected > PROT_SIZE);

    // Visit all candidates to find victim
    ReplaceableEntry* victim = candidates[0];
    for (const auto& candidate : candidates) {
        // Update victim entry if necessary and unprotected
        if (std::static_pointer_cast<SLRUReplData>(
                    candidate->replacementData)->lastTouchTick <
                std::static_pointer_cast<SLRUReplData>(
                    victim->replacementData)->lastTouchTick &&
                std::static_pointer_cast<SLRUReplData>(
                    candidate->replacementData)->protect == 0
            ) {
            victim = candidate;
        }
    }

    return victim;
}

std::shared_ptr<ReplacementData>
SLRURP::instantiateEntry()
{
    return std::shared_ptr<ReplacementData>(new SLRUReplData());
}

SLRURP*
SLRURPParams::create()
{
    return new SLRURP(this);
}
