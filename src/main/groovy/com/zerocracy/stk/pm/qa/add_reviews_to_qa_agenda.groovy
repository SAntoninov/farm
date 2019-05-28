/*
 * Copyright (c) 2016-2019 Zerocracy
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to read
 * the Software only. Permissions is hereby NOT GRANTED to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.zerocracy.stk.pm.qa


import com.jcabi.xml.XML
import com.zerocracy.Farm
import com.zerocracy.Project
import com.zerocracy.claims.ClaimIn
import com.zerocracy.entry.ClaimsOf
import com.zerocracy.farm.Assume
import com.zerocracy.pm.qa.Reviews
import com.zerocracy.pm.staff.Roles
import com.zerocracy.pmo.Agenda
import com.zerocracy.pmo.People
import org.cactoos.collection.Filtered

def exec(Project project, XML xml) {
  new Assume(project, xml).notPmo()
  new Assume(project, xml).type('Ping daily')
  Farm farm = binding.variables.farm
  new Roles(project).bootstrap().findByRole('QA').each { login ->
    if (new People(farm).bootstrap().vacation(login)) {
      return
    }
    List<String> reviews = new Reviews(project).bootstrap().findByInspector(login)
    Agenda agenda = new Agenda(farm, login).bootstrap()
    Collection<String> jobs = agenda.jobs()
    boolean updated = false
    new Filtered<>({job -> !jobs.contains(job)}, reviews).each { job ->
      agenda.add(project, job, 'QA')
      updated = true
    }
    if (updated) {
      new ClaimIn(xml).copy()
        .type('Agenda was updated')
        .param('login', login)
        .postTo(new ClaimsOf(farm))
    }
  }
}
